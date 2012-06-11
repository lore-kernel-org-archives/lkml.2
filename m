Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab2FKBk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 21:40:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26886 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2FKBkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 21:40:24 -0400
X-AuditID: cbfee60f-b7f406d00000703d-40-4fd54c87c34e
Date: Mon, 11 Jun 2012 01:40:23 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/1] mfd: max8997: Add missing static storage class
 specifier
To: Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "patches@linaro.org" <patches@linaro.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120611012943698@myungjoo.ham
Msgkey: 20120611012943698@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120611012943698@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <2343140.762561339378822682.JavaMail.weblogic@epml04>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t/tmbrtPlf9DTZsk7a4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZz3efYCvYJ17x59BNxgbGN2JdjJwcQgLqEouWnGQDsSUETCSm
	PL3ACGGLSVy4tx4ozgVUM59RYuXi6+wgCRYBVYlVLb+Aijg42AT0JGZ+TgYJCwsESjzY+4cZ
	xBYRyJV4tfc32ExmgQSJrgd72SF2KUms2feKBcTmFRCUODnzCQvELlWJ8+d7WCHiahKf7+1h
	hohLSMyafoEVwuaVmNH+FKpeTmLa1zVQNdIS52dtgLt58ffHUHF+iWO3dzCBnAnS++R+MMyY
	3Zu/QL0rIDH1zEGgVnYgW0viZjxElE9izcK3LDBDdp1azgzxiKLElO6H7BC2lsSXH/vYUD3C
	AWQ7SrTMKp/AKDsLSWYWku5ZSLqR1SxgZFnFKJpakFxQnJSeaqpXnJhbXJqXrpecn7uJERzH
	z/h3MC5qsDjEKMDBqMTD+977qr8Qa2JZcWXuIUYJDmYlEd6tTJf8hXhTEiurUovy44tKc1KL
	DzFKc7AoifP2Wl/wFxJITyxJzU5NLUgtgskycXBKNTBmOLmopwYya4mK7DgrbNRQ1ziv4sfG
	0Nsmz/oeOhXMqvz7hfVdQqfVuRfOj1ZuCn3Tal3rnuxfIDf9+OKlp+ZFFrivXGv6Z8/UfuHW
	MxdrZk/+195g9PqKx89F/BOFc+9+e75HmMvW4bFUXblUVeWJM7Mm+ssHe/56KVPceq6Y0cp+
	457p3LOUWIozEg21mIuKEwEUh3fG3wIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5B1eVCQ005648

Sachin Kamat<sachin.kamat@linaro.org> Date : 2012-06-04 20:09 (GMT+09:00)
> 
> Fixes the following sparse warnings:
> drivers/mfd/max8997.c:209:4: warning: symbol 'max8997_dumpaddr_pmic' was not declared. Should it be static?
> drivers/mfd/max8997.c:334:4: warning: symbol 'max8997_dumpaddr_muic' was not declared. Should it be static?
> drivers/mfd/max8997.c:344:4: warning: symbol 'max8997_dumpaddr_haptic' was not declared. Should it be static?
> drivers/mfd/max8997.c:426:25: warning: symbol 'max8997_pm' was not declared. Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
> drivers/mfd/max8997.c |    8 ++++----
> 1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index cb83a7a..454f499 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -206,7 +206,7 @@ static const struct i2c_device_id max8997_i2c_id[] = {
> };
> MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
> 
> -u8 max8997_dumpaddr_pmic[] = {
> +static u8 max8997_dumpaddr_pmic[] = {
> MAX8997_REG_INT1MSK,
> MAX8997_REG_INT2MSK,
> MAX8997_REG_INT3MSK,
> @@ -331,7 +331,7 @@ u8 max8997_dumpaddr_pmic[] = {
> MAX8997_REG_DVSOKTIMER5,
> };
> 
> -u8 max8997_dumpaddr_muic[] = {
> +static u8 max8997_dumpaddr_muic[] = {
> MAX8997_MUIC_REG_INTMASK1,
> MAX8997_MUIC_REG_INTMASK2,
> MAX8997_MUIC_REG_INTMASK3,
> @@ -341,7 +341,7 @@ u8 max8997_dumpaddr_muic[] = {
> MAX8997_MUIC_REG_CONTROL3,
> };
> 
> -u8 max8997_dumpaddr_haptic[] = {
> +static u8 max8997_dumpaddr_haptic[] = {
> MAX8997_HAPTIC_REG_CONF1,
> MAX8997_HAPTIC_REG_CONF2,
> MAX8997_HAPTIC_REG_DRVCONF,
> @@ -423,7 +423,7 @@ static int max8997_resume(struct device *dev)
> return max8997_irq_resume(max8997);
> }
> 
> -const struct dev_pm_ops max8997_pm = {
> +static const struct dev_pm_ops max8997_pm = {
> .suspend = max8997_suspend,
> .resume = max8997_resume,
> .freeze = max8997_freeze,
> -- 
> 1.7.4.1
> 

--
MyungJoo Ham («‘∏Ì¡÷), PHD
System S/W Lab, S/W Platform Team, Software Center
Samsung Electronics
Cell: +82-10-6714-2858

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
