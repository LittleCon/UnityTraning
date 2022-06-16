// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 5/V2F Example Shader"
{
    Properties{
        //这里定义的是ShaderLab的类型，CGPROGRAM和ENDCG之间定义的是CG/HLSL的类型
        _Color("Customer Color",Color) = (1.0,1.0,1.0)
    }
    SubShader
    {
        //该pass展示了顶点着色器和片元着色器之间的通信
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            //定义一个和属性名称和类型都匹配的字段，会自动获取属性的值
            fixed4 _Color;

            //使用一个结构体来定义顶点着色器的输入
            struct a2v {
                //POSITION语义告诉Unit，用模型空间的顶点坐标来填充vertex变量
                float4 vertex:POSITION;
                // NORMAL语义告诉Unity，用模型空间的法线方向填充normal变量
                float3 normal:NORMAL;
                // TEXCOORD0语义告诉Unity，用模型的第一套纹理坐标填充texcoord变量
                float4 texcoord:TEXCOORD0;
            };

            struct v2f{
                //SV_POSITION是告诉UNity vert这个函数返回的值——裁剪空间中的顶点坐标
                float4 pos:SV_POSITION;
                //COLOR0 用于存储颜色
                fixed3 color :COLOR0;
            };

            //该结构体用于顶点着色器和片元着色器之间传递信息
            v2f vert(a2v v){
                v2f o;
                //mul是矩阵相乘函数
                //UNITY_MATRIX_MVP是内置的模型·观察·投影矩阵
                o.pos = UnityObjectToClipPos(v.vertex);

                //v.noraml 包含了顶点的法线方向，其分量范围在-1.0~1.0的闭区间内
                o.color = v.normal *0.5 + fixed3 (0.5,0.5,0.5);
                return o;
            }

            //SV_TARGET语义指的是告诉渲染器把用户输出的颜色存储到一个渲染目标中
            fixed4 frag(v2f i):SV_TARGET{
                fixed3 c = i.color;
                c *= _Color.rgb;
                return fixed4(c,1.0);
            }
            ENDCG

        }
        
    }
}