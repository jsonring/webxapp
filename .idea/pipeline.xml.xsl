<?xml version="1.0" encoding="UTF-8" ?>
<beans:beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xmlns:services="http://www.alibaba.com/schema/services"
             xmlns:pl-conditions="http://www.alibaba.com/schema/services/pipeline/conditions"
             xmlns:pl-valves="http://www.alibaba.com/schema/services/pipeline/valves"
             xmlns:beans="http://www.springframework.org/schema/beans"
             xmlns:p="http://www.springframework.org/schema/p"
             xsi:schemaLocation="
        http://www.alibaba.com/schema/services
                http://localhost:8080/schema/services.xsd
        http://www.alibaba.com/schema/services/pipeline/conditions
                http://localhost:8080/schema/services-pipeline-conditions.xsd
        http://www.alibaba.com/schema/services/pipeline/valves
                http://localhost:8080/schema/services-pipeline-valves.xsd
        http://www.springframework.org/schema/beans
                http://localhost:8080/schema/www.springframework.org/schema/beans/spring-beans.xsd
    ">

    <services:pipeline xmlns="http://www.alibaba.com/schema/services/pipeline/valves">

        <!-- 初始化turbine rundata，并在pipelineContext中设置可能会用到的对象(如rundata、utils)，以便valve取得。 -->
        <prepareForTurbine />

        <!-- 设置日志系统的上下文，支持把当前请求的详情打印在日志中。 -->
        <setLoggingContext />

        <!-- 分析URL，取得target。 -->
        <analyzeURL homepage="homepage" />

        <!-- 检查csrf token，防止csrf攻击和重复提交。 -->
        <checkCsrfToken />

        <loop>
            <choose>
                <when>
                    <!-- 执行带模板的screen，默认有layout。 -->
                    <pl-conditions:target-extension-condition extension="null, vm, jsp" />
                    <performAction />
                    <performTemplateScreen />
                    <renderTemplate />
                </when>
                <when>
                    <!-- 执行不带模板的screen，默认无layout。 -->
                    <pl-conditions:target-extension-condition extension="do" />
                    <performAction />
                    <performScreen />
                </when>
                <otherwise>
                    <!-- 将控制交还给servlet engine。 -->
                    <exit />
                </otherwise>
            </choose>

            <!-- 假如rundata.setRedirectTarget()被设置，则循环，否则退出循环。 -->
            <breakUnlessTargetRedirected />
        </loop>

    </services:pipeline>

</beans:beans>