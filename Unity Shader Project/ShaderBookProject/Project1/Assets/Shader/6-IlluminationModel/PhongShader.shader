Shader "Custom/PhongShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        
    }
    SubShader
    {
       Pass{
        Tags {"LightMode" = "ForWardBase" }
        CGPROGRAM
        #include Lighting.cginc
        #pragma vertex vert 
        #pragma fragment frag 
        fixed4 _Color;
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
            float3 worldNormal = UnityObjectToWorldNormal(v.normal);
            float3 reflect = 2*dot(dot(worldNormal,_WorldSpaceLightPos0.xyz),worldNormal)-_WorldSpaceLightPos0.xyz

        }
        ENDCG
       }
    }
    FallBack "Diffuse"
}
