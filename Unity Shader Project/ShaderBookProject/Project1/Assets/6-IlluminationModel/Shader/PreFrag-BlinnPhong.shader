

Shader "Custom/PreVertex-PhongShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Specular ("Specular",Color) = (1,1,1,1)
        _Gloss ("Gloss",Range(8.0,256)) = 20
        
    }
    SubShader
    {
       Pass{
        Tags {"LightMode" = "ForWardBase" }
        CGPROGRAM
        #include "Lighting.cginc"
        #pragma vertex vert 
        #pragma fragment frag 
        fixed4 _Color;
        fixed4 _Specular;
        fixed4 _Gloss;
        struct a2v{
            float4 vertex:POSITION;
            float3 normal:NORMAL;
        };
        struct v2f{
            float4 pos:SV_POSITION;
            float3 normal:TEXCOORD0;
            float3 worldPos:TEXCOORD1;
        };
        v2f vert(a2v v){
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.normal = v.normal;
            o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
            return o;
        }
        fixed4 frag(v2f i):SV_Target{
            float3 worldNormal = normalize(mul(unity_WorldToObject,i.normal));
            float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
            
            //float3 reflectDir = reflect(-worldLightDir,worldNormal);
           
            float3 viewDir = normalize(_WorldSpaceCameraPos.xyz-i.worldPos.xyz);
             float3 halfDir = normalize(worldLightDir+viewDir);
            float3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal , halfDir)),_Gloss);
            fixed3 diffuse = _LightColor0.rgb * _Color . rgb * saturate(dot(worldNormal, worldLightDir));
            //diffuse 是漫反射，UNITY_LIGHTMODEL_AMBIENT是环境光
            float3 color = specular+diffuse;
            return float4(color + UNITY_LIGHTMODEL_AMBIENT.xyz,1.0);

        }
        ENDCG
       }
    }
    FallBack "Diffuse"
}
