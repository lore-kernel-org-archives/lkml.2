Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2LJGUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:20:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63131 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2LJGU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:20:27 -0500
X-AuditID: cbfee61b-b7f616d00000319b-56-50c57f2a62bb
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Cc: dianders@chromium.org, olof@lixom.net, grant.likely@secretlab.ca,
        thomas.abraham@linaro.org, kgene.kim@samsung.com,
        sameo@linux.intel.com, Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [RFC PATCH 1/3] ARM: DTS: CROS5250: Add regulator operating mode
 bindings
Date: Mon, 10 Dec 2012 11:56:22 +0530
Message-id: <1355120784-31118-2-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.6.6.1
In-reply-to: <1355120784-31118-1-git-send-email-a.kesavan@samsung.com>
References: <1355120784-31118-1-git-send-email-a.kesavan@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkSler/miAwdcdshaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjyp73rAXd6hXbz81maWCcJNPFyMkhIWAicenRDCYIW0ziwr31
	bF2MXBxCAksZJXpvbmSEKbr45T87RGIRo8T1DV9YIZzlTBLnN79gBqliE9CTWPDvK5gtIhAs
	MftnA9goZoHdjBIP3iwBSnBwCAuESMy8XAJSwyKgKvHm7SJWEJtXwFVi4sVtUGcoSJz+sJYd
	xOYUcJO4tvMZ2BVCQDVXu4+wQPQKSHybfIgFZKSEgKzEpgPMIKskBK6zSWw6/IQVYo6kxMEV
	N1gmMAovYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREYhKf/PZPewbiqweIQowAHoxIP
	b4Di0QAh1sSy4srcQ4wSHMxKIrxcx44ECPGmJFZWpRblxxeV5qQWH2L0AbpkIrOUaHI+MELy
	SuINjU3MTY1NLY2MzExNcQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamC0a4r7qqtmzdS2
	ZPqnDzlpHdlz2RvMBFdGrnY0CbR2szwWGPu7YNfJHovPXHJb2Zcxdb10Wvz3pGmjvu2Ne7PX
	+V8vjH98yeR52a+923/dqbic/VZkjvf3hF2srLZn/j/+9E+sJ37dv3ubtLS/fkzNunx3pk/z
	1AVhBs9d1s7dtL7kSKty+e4YJZbijERDLeai4kQAM/1Hc28CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xgK5W/dEAgwuPeS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxpQ971kLutUrtp+bzdLA
	OEmmi5GTQ0LAROLil//sELaYxIV769m6GLk4hAQWMUpc3/CFFcJZziRxfvMLZpAqNgE9iQX/
	voLZIgLBErN/NoB1MAvsZpR48GYJUIKDQ1ggRGLm5RKQGhYBVYk3bxexgti8Aq4SEy9uY4LY
	piBx+sNasM2cAm4S13Y+YwSxhYBqrnYfYZnAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5y
	fu4mRnCIP5PewbiqweIQowAHoxIPb4Di0QAh1sSy4srcQ4wSHMxKIrxcx44ECPGmJFZWpRbl
	xxeV5qQWH2L0AbpqIrOUaHI+MP7ySuINjU3MTY1NLU0sTMwscQgrifM2e6QECAmkJ5akZqem
	FqQWwYxj4uCUamBcmOFgcsVrtcOadb5GfToyrp/kJ194fvwx9+ec3X5Cls2Jf69/3vX4h/sn
	0Yqj5n9YZLQuzS1oZVCdmSiubSDnNF/59as5Ps+utJ8xm7FnhVTM9gi3rburUxhD3Vc9v7Bp
	8d5tTg6cJtf6WDue3vvy5fRJJRmepW9fzwxQtCo47Dvh0K9jjMJXlFiKMxINtZiLihMBR8wF
	WZ4CAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the LDOs and BUCKs on the MAX77686 PMIC can be put into a
low power or standby state. Add bindings to control the operating
mode. This results in significant power savings during suspend.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
 arch/arm/boot/dts/cros5250-common.dtsi |   36 ++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/cros5250-common.dtsi b/arch/arm/boot/dts/cros5250-common.dtsi
index 98ff65b..10d1812 100644
--- a/arch/arm/boot/dts/cros5250-common.dtsi
+++ b/arch/arm/boot/dts/cros5250-common.dtsi
@@ -35,6 +35,8 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
+					/* Output ON/LPM controlled by PWRREQ */
+					max77686-opmode = <0x40>;
 				};
 
 				ldo2_reg: LDO2 {
@@ -42,6 +44,8 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x20>;
 				};
 
 				ldo3_reg: LDO3 {
@@ -49,6 +53,8 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
+					/* Output ON/LPM controlled by PWRREQ */
+					max77686-opmode = <0x80>;
 				};
 
 				ldo7_reg: LDO7 {
@@ -56,6 +62,8 @@
 					regulator-min-microvolt = <1100000>;
 					regulator-max-microvolt = <1100000>;
 					regulator-always-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x40>;
 				};
 
 				ldo8_reg: LDO8 {
@@ -63,6 +71,8 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x40>;
 				};
 
 				ldo10_reg: LDO10 {
@@ -70,6 +80,8 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x40>;
 				};
 
 				ldo12_reg: LDO12 {
@@ -77,6 +89,8 @@
 					regulator-min-microvolt = <3000000>;
 					regulator-max-microvolt = <3000000>;
 					regulator-always-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x40>;
 				};
 
 				ldo14_reg: LDO14 {
@@ -84,6 +98,8 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x40>;
 				};
 
 				ldo15_reg: LDO15 {
@@ -91,6 +107,8 @@
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x40>;
 				};
 
 				ldo16_reg: LDO16 {
@@ -98,6 +116,8 @@
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x40>;
 				};
 
 				buck1_reg: BUCK1 {
@@ -106,6 +126,8 @@
 					regulator-max-microvolt = <1300000>;
 					regulator-always-on;
 					regulator-boot-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x1>;
 				};
 
 				buck2_reg: BUCK2 {
@@ -114,6 +136,8 @@
 					regulator-max-microvolt = <1350000>;
 					regulator-always-on;
 					regulator-boot-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x10>;
 				};
 
 				buck3_reg: BUCK3 {
@@ -122,6 +146,8 @@
 					regulator-max-microvolt = <1200000>;
 					regulator-always-on;
 					regulator-boot-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x10>;
 				};
 
 				buck4_reg: BUCK4 {
@@ -130,6 +156,8 @@
 					regulator-max-microvolt = <1300000>;
 					regulator-always-on;
 					regulator-boot-on;
+					/* Output ON/OFF controlled by PWRREQ */
+					max77686-opmode = <0x10>;
 				};
 
 				buck5_reg: BUCK5 {
@@ -138,6 +166,8 @@
 					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
 					regulator-boot-on;
+					/* Output ON */
+					max77686-opmode = <0x3>;
 				};
 
 				buck6_reg: BUCK6 {
@@ -145,6 +175,8 @@
 					regulator-min-microvolt = <1350000>;
 					regulator-max-microvolt = <1350000>;
 					regulator-always-on;
+					/* Output ON */
+					max77686-opmode = <0x3>;
 				};
 
 				buck7_reg: BUCK7 {
@@ -152,6 +184,8 @@
 					regulator-min-microvolt = <2000000>;
 					regulator-max-microvolt = <2000000>;
 					regulator-always-on;
+					/* Output ON */
+					max77686-opmode = <0x3>;
 				};
 
 				buck8_reg: BUCK8 {
@@ -159,6 +193,8 @@
 					regulator-min-microvolt = <2850000>;
 					regulator-max-microvolt = <2850000>;
 					regulator-always-on;
+					/* Output OFF of ENB8 is low */
+					max77686-opmode = <0x1>;
 				};
 			};
 		};
-- 
1.7.8.6

