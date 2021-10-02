<%@ page contentType="text/html;charset=UTF-8" language="java" %>   <%--jsp--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    <%--jstl--%>
<%
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + request.getContextPath() + "/";
%>  <%--取base--%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>" />
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="layuimini/lib/layui-v2.6.3/css/layui.css" media="all">
    <link rel="stylesheet" href="layuimini/css/public.css" media="all">
    <script src="layuimini/lib/layui-v2.6.3/layui.js" charset="utf-8"></script>
    <script src="layuimini/lib/jquery-3.4.1/jquery-3.4.1.min.js" charset="utf-8"></script>
</head>
<body>
<%--数据表格布局--%>
<div class="layuimini-container">
    <div class="layuimini-main">
        <%--搜索信息--%>
        <fieldset class="table-search-fieldset">
            <legend>搜索信息</legend>
            <div style="margin: 10px 10px 10px 10px">
                <form class="layui-form layui-form-pane" action="" lay-filter="searchForm">
                    <div class="layui-form-item">
                        <!--学年-->
                        <div class="layui-inline">
                            <label class="layui-form-label">学年</label>
                            <div class="layui-input-inline">
                                <input type="text" name="year" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <!--学期-->
                        <div class="layui-inline">
                            <label class="layui-form-label">学期</label>
                            <div class="layui-input-inline">
                                <input type="text" name="term" autocomplete="off" class="layui-input">
                            </div>
                        </div>
                        <%--班级--%>
                        <div class="layui-inline">
                            <label class="layui-form-label">班级</label>
                            <div class="layui-input-inline">
                                <select name="cid" id="search_cid" lay-search="">
                                    <option value="">请选择班级</option>
                                </select>
                            </div>
                        </div>
                        <%--课程--%>
                        <div class="layui-inline">
                            <label class="layui-form-label">课程</label>
                            <div class="layui-input-inline">
                                <select name="courseId" id="search_courseId" lay-search="">
                                    <option value="">请选择课程</option>
                                </select>
                            </div>
                        </div>
                        <br/>
                        <div class="layui-inline">
                            <button type="submit" class="layui-btn layui-btn-primary"  lay-submit lay-filter="data-search-btn"><i class="layui-icon"></i> 搜　　索 </button>
                        </div>
                        <div class="layui-inline">
                            <button type="submit" class="layui-btn layui-btn-primary"  lay-submit lay-filter="data-all-btn"><i class="layui-icon"></i> 显示全部 </button>
                        </div>
                    </div>
                </form>
            </div>
        </fieldset>
        <%--头部工具栏--%>
        <script type="text/html" id="toolbarDemo">
            <div class="layui-btn-container">
                <button class="layui-btn layui-btn-sm layui-btn-warm data-plan-btn" lay-event="plan"> 查看排课 </button>
                <button class="layui-btn layui-btn-sm layui-btn-normal data-plan-btn" lay-event="score"> 录入成绩 </button>
            </div>
        </script>
        <%--表格容器--%>
        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>
    </div>
</div>
<%--js代码--%>
<script>
    layui.use(['form', 'table'], function () {
        var $ = layui.jquery, form = layui.form, table = layui.table;

        $(function () {
            //获取所有的班级、教师、课程信息
            $.getJSON({
                url: 'clazz/queryAllClazzsByTeacher.do',
                success: function (data) {
                    $("#search_cid").html();
                    $.each(data,function (i,n) {
                        $("#search_cid")
                            .append("<option value=\""+n.cid+"\">"+n.cname+"</option>")
                    });
                    $("#edit_cid").html();
                    $.each(data,function (i,n) {
                        $("#edit_cid")
                            .append("<option value=\""+n.cid+"\">"+n.cname+"</option>")
                    });
                    form.render('select','searchForm'); //刷新select选择框渲染
                    form.render('select','editForm'); //刷新select选择框渲染
                }
            });
            $.getJSON({
                url: 'course/queryAllCoursesByTeacher.do',
                success: function (data) {
                    $("#search_courseId").html();
                    $.each(data,function (i,n) {
                        $("#search_courseId")
                            .append("<option value=\""+n.courseId+"\">"+n.courseName+"</option>")
                    });
                    $("#edit_courseId").html();
                    $.each(data,function (i,n) {
                        $("#edit_courseId")
                            .append("<option value=\""+n.courseId+"\">"+n.courseName+"</option>")
                    });
                    form.render('select','searchForm'); //刷新select选择框渲染
                    form.render('select','editForm'); //刷新select选择框渲染
                }
            });
        });

        //加载数据表格
        table.render({
            elem: '#currentTableId',
            url: 'openCourse/queryOpenCoursesByTeacher.do',
            toolbar: '#toolbarDemo',
            defaultToolbar: ['filter', 'exports', 'print', {
                title: '提示',
                layEvent: 'LAYTABLE_TIPS',
                icon: 'layui-icon-tips'
            }],
            cols: [[
                {type: "checkbox"},
                {field: 'oid', title: '序号', sort: true},
                {field: 'year', title: '学年'},
                {field: 'term', title: '学期'},
                {field: 'cname', title: '班级名'},
                {field: 'tname', title: '教师名'},
                {field: 'courseName', title: '课程名'}
            ]],
            limits: [5, 10, 15, 20, 25, 50, 100],
            limit: 10,
            page: {
                prev: '上一页',
                next: '下一页',
            },
            skin: 'line'
        });

        // 监听搜索操作
        form.on('submit(data-search-btn)', function (data) {
            var result = JSON.stringify(data.field);

            //执行搜索重载
            table.reload('currentTableId', {
                url: 'openCourse/searchOpenCourses.do',
                where: {json:result},   //把json传过去
                page: {curr: 1}, //重新从第 1 页开始
                done: function (res) {
                    layer.msg("搜索到"+res.count+"个结果", {time:800});
                    return res;
                }
            });

            return false;   //不跳转
        });

        // 监听显示全部操作
        form.on('submit(data-all-btn)', function (data) {
            form.val("searchForm", {
                'year':null,
                'term':null,
                'cid':null,
                'tid':null,
                'courseId':null,
            });
            //执行搜索重载
            table.reload('currentTableId', {
                url: 'openCourse/queryOpenCourses.do',
                page: {curr: 1}, //重新从第 1 页开始
                done: null
            });
            return false;   //不跳转
        });

        //toolbar监听事件
        table.on('toolbar(currentTableFilter)', function (obj) {
            if (obj.event === 'plan') {  //监听查看排课操作
                var checkStatus = table.checkStatus('currentTableId')
                    , data = checkStatus.data;

                console.log(data);
                if(data.length != 1) {
                    layer.msg("请选择一行记录！",{time:1000});
                    return false;
                }

                layer.open({
                    title: "查看排课",
                    type: 2,    //iframe
                    maxmin: true,
                    shadeClose: true,
                    area: ['90%', '90%'],
                    btn: ['确定'],
                    content: 'teacher/teacher_course_table_list.jsp?oid=' + data[0].oid,
                    yes: function (index, layero) { //确认的回调
                        layer.close(index); //关闭弹出框
                    }
                })
            } else if(obj.event === 'score') {
                var checkStatus = table.checkStatus('currentTableId')
                    , data = checkStatus.data;
                console.log(data);
                if(data.length != 1) {
                    layer.msg("请选择一行记录！",{time:1000});
                    return false;
                }
                layer.open({
                    title: "录入成绩",
                    type: 2,    //iframe
                    maxmin: true,
                    shadeClose: true,
                    area: ['500px', '90%'],
                    /*btn: ['确定'],*/
                    content: 'teacher/teacher_score.jsp?oid=' + data[0].oid,
                    /*yes: function (index, layero) { //确认的回调
                        layer.close(index); //关闭弹出框
                    }*/
                })
            }
        });

        table.on('tool(currentTableFilter)', function (obj) {
            if (obj.event === 'edit') { //监听编辑按钮
                var index = layer.open({
                    title: '编辑用户',
                    type: 1,    //界面层
                    maxmin:true,
                    shadeClose: true,
                    area: ['500px', '450px'],
                    btn: ['确定', '取消'],
                    content: $("#edit_window"),
                    success: function () {
                        var mdata = obj.data;   //获取该行的数据
                        //给表单赋值
                        form.val("editForm", {
                            "oid": mdata.oid,
                            "year": mdata.year,
                            "term": mdata.term,
                            "cid": mdata.cid,
                            "tid": mdata.tid,
                            "courseId": mdata.courseId,
                            "remark": mdata.remark
                        });
                    },
                    yes: function () {  //确认回调
                        layer.close(index); //关闭弹出框
                        var mdata = form.val('editForm');   //获取表单的数据
                        $.getJSON({
                            url: 'openCourse/updateOpenCourse.do',
                            data: {json:JSON.stringify(mdata)},   //发json过去
                            success:function (res) {
                                layer.msg("修改"+res+"行成功!",{time:800});
                                //重载表格
                                table.reload('currentTableId');
                            }
                        });
                    }
                });
                $(window).on("resize", function () {
                    layer.full(index);
                });
                return false;
            } else if (obj.event === 'delete') {    //监听删除按钮
                layer.confirm('确定要删除该行吗？', function (index) {
                    var mdata = obj.data;    //获取该行的数据
                    obj.del();  //删除对应行（tr）的DOM结构，并更新缓存
                    layer.close(index); //关闭窗口
                    //向服务器请求
                    $.getJSON({
                        url: 'openCourse/deleteOpenCourses.do',
                        data: {json:JSON.stringify(mdata)},   //发json过去
                        success:function (res) {
                            layer.msg("删除"+res+"行成功！",{time:800});
                        }
                    });
                });
            }
        });

    });
</script>

</body>
</html>