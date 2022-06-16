// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 7/SingleTxture"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _Specular ("Specular", Color) = (1,1,1,1)
        _Gloss ("Gloss", Range(8.0,256)) = 20
    }
    SubShader
    {
      Pass{
        Tags{ "LightMode" = "ForwardBass" }
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "Lighting.cginc"

        //变量声明
        float4 _Color;
        sampler2D _MainTex;
        //为纹理类型属性声明的 ST代表了Scale和translate——即改值用来获取纹理的缩放和平移
        //_MainTex_ST.xy存储的是缩放值，_MainTex_ST.zw存储的是偏移值
        float4 _MainTex_ST;
        fixed4 _Gloss;
        fixed4 _Specular;

        struct a2v{
          float4 vertex : POSITION;
          float3 normal : NORMAL;
          float4 texcoord:TEXCOORD0;
        };

        struct v2f{
          float4 pos:SV_POSITION;
          float3 worldNormal :TEXCOORD0;
          float3 worldPos:TEXCOORD1;
          float2 uv:TEXCOORD2;
        };
        
        v2f vert(a2v v){
          v2f o;
          o.pos = UnityObjectToClipPos(v.vertex);
          o.worldNormal = UnityObjectToWorldNormal(v.normal);
          o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
          //通过 o.uv = TRANSFORM_TEX(v.texcoord,_MainTEx);可以替换下行过程
          //TRANSFORM_TEX是Unity内置的方法，第一个参数是纹理顶点坐标，第二个参数是纹理名
          o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
          return o;
        }

        fixed4 frag(v2f i):SV_target{
          fixed3 worldNormal = normalize(i.worldNormal);
          fixed3 worldLightDir=normalize(UnityWorldSpaceLightDir(i.worldPos));

          fixed3 albedo = tex2D(_MainTex,i.uv).rgb * _Color.rgb;
          fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
          fixed3 diffuse = _LightColor0.rgb * albedo * max(0,dot(worldNormal,worldLightDir));
          fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
          fixed3 halfDir = normalize(worldLightDir + viewDir);
          fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow( max(0,dot(worldNormal,halfDir)),_Gloss);
          return fixed4(ambient + diffuse + specular,1.0);
        }

        ENDCG
      }
    }
    FallBack "Diffuse"
}
