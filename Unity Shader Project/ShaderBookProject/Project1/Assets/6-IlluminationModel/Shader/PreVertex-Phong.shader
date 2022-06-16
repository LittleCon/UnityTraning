
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
            fixed3 color:COLOR;
        };
        v2f vert(a2v v){
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
            fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
            //worldLightDir是平行光的方向，而我们要的参数是法线和入射方向。
            //前提：向量A-向量B假设得到向量C  向量C的方向是从B->A的
            //CG函数要求的入射方向是光源指向焦点，因此 焦点-光源=入射方向
            fixed3 reflectDir = normalize(reflect(-worldLightDir,worldNormal));
            //视角方向指 物体->摄像机
            fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz-mul(unity_ObjectToWorld,v.vertex).xyz);
            fixed3 diffuse = _LightColor0.rgb * _Color.rgb * saturate(dot(worldNormal,worldLightDir));
            fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir,viewDir)),_Gloss);
            o.color = specular +diffuse + UNITY_LIGHTMODEL_AMBIENT.xyz ;
            return o;
        }
        fixed4 frag(v2f i):SV_Target{
            return fixed4(i.color,1.0);
        }
        ENDCG
       }
    }
    FallBack "Diffuse"
}
