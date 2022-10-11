---先删后写，直接覆盖，使用于数据不会更新也不新增，也不需要维护历史状态
CREATE TABLE t_district
(
    id    string COMMENT '主键ID',
    code  string COMMENT '区域编码',
    name  string COMMENT '区域名称',
    pid   INT  COMMENT '父级ID',
    alias string COMMENT '别名'
)comment '区域字典表'
row format delimited
fields terminated by '\t'
stored as  orc
tblproperties ('orc.compress'='ZLIB');
select * from   t_district;
---每天新增一个日期分区，同步并存储当天的新增数据
CREATE TABLE if not exists t_user_login
(
    id          string,
    login_user  string,
    login_type  string COMMENT '登录类型（登陆时使用）',
    client_id   string COMMENT '推送标示id(登录、第三方登录、注册、支付回调、给用户推送消息时使用)',
    login_time  string  ,
    login_ip    string,
    logout_time  string
)comment '用户登录记录表'
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties('orc.compress'='ZLIB');
---
---首次全量导入
select login_time from yp_ods.t_user_login order by login_time desc limit 10;

------新增一个日期分区，同步并存储当天的新增和更新数据
CREATE TABLE yp_ods.t_store
(
    `id`                 string COMMENT '主键',
    `user_id`            string,
    `store_avatar`       string COMMENT '店铺头像',
    `address_info`       string COMMENT '店铺详细地址',
    `name`               string COMMENT '店铺名称',
    `store_phone`        string COMMENT '联系电话',
    `province_id`        INT COMMENT '店铺所在省份ID',
    `city_id`            INT COMMENT '店铺所在城市ID',
    `area_id`            INT COMMENT '店铺所在县ID',
    `mb_title_img`       string COMMENT '手机店铺 页头背景图',
    `store_description` string COMMENT '店铺描述',
    `notice`             string COMMENT '店铺公告',
    `is_pay_bond`        TINYINT COMMENT '是否有交过保证金 1：是0：否',
    `trade_area_id`      string COMMENT '归属商圈ID',
    `delivery_method`    TINYINT COMMENT '配送方式  1 ：自提 ；3 ：自提加配送均可; 2 : 商家配送',
    `origin_price`       DECIMAL,
    `free_price`         DECIMAL,
    `store_type`         INT COMMENT '店铺类型 22天街网店 23实体店 24直营店铺 33会员专区店',
    `store_label`        string COMMENT '店铺logo',
    `search_key`         string COMMENT '店铺搜索关键字',
    `end_time`           string COMMENT '营业结束时间',
    `start_time`         string COMMENT '营业开始时间',
    `operating_status`   TINYINT COMMENT '营业状态  0 ：未营业 ；1 ：正在营业',
    `create_user`        string,
    `create_time`        string,
    `update_user`        string,
    `update_time`        string,
    `is_valid`           TINYINT COMMENT '0关闭，1开启，3店铺申请中',
    `state`              string COMMENT '可使用的支付类型:MONEY金钱支付;CASHCOUPON现金券支付',
    `idCard`             string COMMENT '身份证',
    `deposit_amount`     DECIMAL(11,2) COMMENT '商圈认购费用总额',
    `delivery_config_id` string COMMENT '配送配置表关联ID',
    `aip_user_id`        string COMMENT '通联支付标识ID',
    `search_name`        string COMMENT '模糊搜索名称字段:名称_+真实名称',
    `automatic_order`    TINYINT COMMENT '是否开启自动接单功能 1：是  0 ：否',
    `is_primary`         TINYINT COMMENT '是否是总店 1: 是 2: 不是',
    `parent_store_id`    string COMMENT '父级店铺的id，只有当is_primary类型为2时有效'
)
comment '店铺表'
partitioned by (dt string)
row format delimited
fields terminated by '\t'
stored as orc
tblproperties('orc.compress'='ZLIB');

--where 条件判断导入
truncate table t_store;
select * from t_store;
drop table t_store;
select count(*) from t_store;