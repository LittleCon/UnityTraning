Shader "Custom/PreVertex-LambertModel"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass{
            Tags {"LightMode" = "ForWardBase"}
            CGPROGRAM
            #pragma vertex vert
            #include "UnityCG.cginc"
            #pragma fragment frag
            #include "Lighting.cginc"
            fixed4 _Color;

            struct vertexInput{
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };

            struct vertexOutput{
                float4 pos:SV_POSITION;
                fixed3 color:COLOR;
            };

            vertexOutput vert(vertexInput v){
                vertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //环境光部分start
                fixed3 ambien = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //环境光部分end

                //物体出现非等比缩放时使用
                //fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));

                //没有缩放或只有等比缩放时使用
                fixed3 worldNormal = UnityObjectToWorldDir(v.normal);
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 diffuse =_LightColor0.rgb * _Color.rgb * saturate(dot(worldNormal,worldLight));
                o.color = diffuse;
                return o; 
            }
            fixed4 frag(vertexOutput i):SV_Target
            {
               return fixed4(i.color,1);
            
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
