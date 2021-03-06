# RUN: onnx-as %s | onnx2tg -march bm1880 -print-module-before-isel -add-dummy-ctable -add-dummy-weight -o=- | FileCheck %s

# CHECK:  name: "res2a_relu_1"
# CHECK-NEXT:  type: "bmnet_eltwise_fixed_forward_bmkernel"
# CHECK-NEXT:  eltwise {
# CHECK-NEXT:    ga_input: {{.*}}
# CHECK-NEXT:    ga_input: {{.*}}
# CHECK-NEXT:    ga_output: {{.*}}
# CHECK-NEXT:    input_size: 2
# CHECK-NEXT:    op: 1
# CHECK-NEXT:    input_n: 1
# CHECK-NEXT:    input_c: 64
# CHECK-NEXT:    input_h: 56
# CHECK-NEXT:    input_w: 56
# CHECK-NEXT:    do_relu: true
# CHECK-NEXT:    relu_slope: 0
# CHECK-NEXT:    right_shift_width: {{.*}}
# CHECK-NEXT:    threshold_x_quantized: {{.*}}
# CHECK-NEXT:    threshold_x_quantized: {{.*}}
# CHECK-NEXT:  }
# CHECK-NEXT:}

ir_version: 3
producer_name: "onnx-caffe2"
graph {
  name: "fuse_sum_relu"
  node { input: "data_0" input: "res2a_branch1_w_0" output: "res2a_branch1_1" name: "" op_type: "Conv" attribute { name: "pads" ints: 0 ints: 0 ints: 0 ints: 0 type: INTS } attribute { name: "strides" ints: 1 ints: 1 type: INTS } attribute { name: "kernel_shape" ints: 1 ints: 1 type: INTS } }
  node { input: "data_0" input: "res2a_branch2a_w_0" output: "res2a_branch2a_1" name: "" op_type: "Conv" attribute { name: "pads" ints: 1 ints: 1 ints: 1 ints: 1 type: INTS } attribute { name: "strides" ints: 1 ints: 1 type: INTS } attribute { name: "kernel_shape" ints: 3 ints: 3 type: INTS } }
  node { input: "res2a_branch2a_1" input: "res2a_branch2b_w_0" output: "res2a_branch2b_1" name: "" op_type: "Conv" attribute { name: "pads" ints: 1 ints: 1 ints: 1 ints: 1 type: INTS } attribute { name: "strides" ints: 1 ints: 1 type: INTS } attribute { name: "kernel_shape" ints: 3 ints: 3 type: INTS } }
  node { input: "res2a_branch1_1" input: "res2a_branch2b_1" output: "res2a_1" name: "" op_type: "Add" }
  node { input: "res2a_1" output: "res2a_relu_1" name: "" op_type: "Relu" }
  input { name: "data_0" type { tensor_type { elem_type: FLOAT shape { dim { dim_value: 1 } dim { dim_value: 64 } dim { dim_value: 56 } dim { dim_value: 56 } } } } }
  input { name: "res2a_branch1_w_0" type { tensor_type { elem_type: FLOAT shape { dim { dim_value: 64 } dim { dim_value: 64 } dim { dim_value: 1 } dim { dim_value: 1 } } } } }
  input { name: "res2a_branch2a_w_0" type { tensor_type { elem_type: FLOAT shape { dim { dim_value: 64 } dim { dim_value: 64 } dim { dim_value: 3 } dim { dim_value: 3 } } } } }
  input { name: "res2a_branch2b_w_0" type { tensor_type { elem_type: FLOAT shape { dim { dim_value: 64 } dim { dim_value: 64 } dim { dim_value: 3 } dim { dim_value: 3 } } } } }
  output { name: "res2a_relu_1" type { tensor_type { elem_type: FLOAT shape { dim {dim_value: 1} dim { dim_value: 64 } dim { dim_value: 56 } dim { dim_value: 56} } } } }
}
opset_import { domain: "" version: 6 }
metadata_props { key: "initializers" value: "res2a_branch1_w_0,res2a_branch2a_w_0,res2a_branch2b_w_0" }
