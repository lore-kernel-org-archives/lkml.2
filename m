Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2KTA5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:57:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64952 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2KTA5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:57:35 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-c3-50aad57d446d
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
Cc: "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>
References: 
In-reply-to: 
Subject: [PATCH v3 1/2] thermal: exynos: Fix wrong bit to control tmu core
Date: Tue, 20 Nov 2012 09:57:29 +0900
Message-id: <007301cdc6ba$067107e0$135317a0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22X7ZVF4M1NdAyQSSqkck9CTHe3QA04GwQA+GV/4A=
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI926q6sCDCbUWlzeNYfNgdHj8ya5
	AMYoLpuU1JzMstQifbsEroztG18yFpwVrbi25S5rA+NCgS5GTg4JAROJM2tnM0LYYhIX7q1n
	62Lk4hASWMYo8eXHdzaYomeLfzBCJKYzSkz5/YgJwpnHJHFx9QdWkCo2AV2JY+u3gNkiAtES
	fxr3MIMUMQs0MUocbZ3H3sXIAdTBLbG6OQikhlOAR2Ldn05mEFtYwEvi+J9FYNtYBFQl2s98
	ArN5Bewkrm64zgphC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpDxEgLqEo/+6kKcYCWx7tpK
	qHIRiX0v3jFCjBeQ+Db5EAtEuazEpgPMED8uY5dYco8bwpaUOLjiBssERolZSBbPQrJ4FpLF
	s5BsWMDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjJK6kdjCubLA4xCjAwajEw/swYVWA
	EGtiWXFl7iFGCQ5mJRHepnKgEG9KYmVValF+fFFpTmrxIUYfoMMnMkuJJucDYz6vJN7Q2NjE
	zMTUxNzS1NwUh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsaszRuN+9fwSYp/PBO98lT4
	JctjUw2/THzSKe14vnJ25telCzJ2Knww+LPm5x/3sizz8qKTPafLlkroMgs0BwXafBTfybh3
	z47q2Sqr/sQmm+mvfzPtkei7ORV3/tR+bW9oSVo5+1HM23nfvk2Z+k331R/jGov1Hu8Xl3hm
	eFadCJcrOMx+ZMMMJZbijERDLeai4kQABk6rPNgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jQd3aq6sCDNYcs7S4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGds3vmQsOCtacW3LXdYG
	xoUCXYycHBICJhLPFv9ghLDFJC7cW8/WxcjFISQwnVFiyu9HTBDOPCaJi6s/sIJUsQnoShxb
	vwXMFhGIlvjTuIcZpIhZoIlR4mjrPPYuRg6gDm6J1c1BIDWcAjwS6/50MoPYwgJeEsf/LGID
	sVkEVCXaz3wCs3kF7CSubrjOCmELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmkPESAuoSj/7q
	QpxgJbHu2kqochGJfS/eMU5gFJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWl
	eel6yfm5mxjBkftMagfjygaLQ4wCHIxKPLwPE1YFCLEmlhVX5h5ilOBgVhLhbSoHCvGmJFZW
	pRblxxeV5qQWH2L0AXp0IrOUaHI+MKnklcQbGpuYGVkamVkYmZib4xBWEudt9kgJEBJITyxJ
	zU5NLUgtghnHxMEp1cAYaSGVzatiFXf24qIDvXtz5Te+tOkpr3K8dKxmq8eyBWXV/yRcLRqe
	7ZnsfeWFf6bQjr3zNOr+TLpg47n7+OuNsypbeaICbzZxZmt5KJyQ/pTs+HJ+gU7SnVtN0oXi
	KZ0RTv9uLLG+0br1eer/x/c2vnDvLIzIXMIZabn4Lpfh9/rCjSuzVAqUWIozEg21mIuKEwGw
	0TdGCQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[0]bit is used to enable/disable tmu core. [1] bit is a reserved bit.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/thermal/exynos_thermal.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c
b/drivers/thermal/exynos_thermal.c
index 6dd29e4..129e827 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -52,9 +52,12 @@

 #define EXYNOS_TMU_TRIM_TEMP_MASK      0xff
 #define EXYNOS_TMU_GAIN_SHIFT          8
+#define EXYNOS_TMU_GAIN_MASK           (0xF << EXYNOS_TMU_GAIN_SHIFT)
 #define EXYNOS_TMU_REF_VOLTAGE_SHIFT   24
-#define EXYNOS_TMU_CORE_ON             3
-#define EXYNOS_TMU_CORE_OFF            2
+#define EXYNOS_TMU_REF_VOLTAGE_MASK    (0x1F <<
EXYNOS_TMU_REF_VOLTAGE_SHIFT)
+#define EXYNOS_TMU_CORE_ON             BIT(0)
+#define EXYNOS_TMU_CORE_ON_SHIFT       0
+#define EXYNOS_TMU_CORE_ON_MASK                (0x1 <<
EXYNOS_TMU_CORE_ON_SHIFT)
 #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50

 /* Exynos4210 specific registers */
@@ -85,7 +88,9 @@
 #define EXYNOS_TMU_CLEAR_FALL_INT      (0x111 << 16)
 #define EXYNOS_MUX_ADDR_VALUE          6
 #define EXYNOS_MUX_ADDR_SHIFT          20
+#define EXYNOS_MUX_ADDR_MASK           (0x7 << EXYNOS_MUX_ADDR_SHIFT)
 #define EXYNOS_TMU_TRIP_MODE_SHIFT     13
+#define EXYNOS_TMU_TRIP_MODE_MASK      (0x7 << EXYNOS_TMU_TRIP_MODE_SHIFT)

 #define EFUSE_MIN_VALUE 40
 #define EFUSE_MAX_VALUE 100
@@ -650,10 +655,14 @@ static void exynos_tmu_control(struct platform_device
*pdev, bool on)
        mutex_lock(&data->lock);
        clk_enable(data->clk);

-       con = pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
+       con = readl(data->base + EXYNOS_TMU_REG_CONTROL);
+       con &= ~(EXYNOS_TMU_REF_VOLTAGE_MASK | EXYNOS_TMU_GAIN_MASK |
+               EXYNOS_TMU_CORE_ON_MASK);
+       con |= pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
                pdata->gain << EXYNOS_TMU_GAIN_SHIFT;

        if (data->soc == SOC_ARCH_EXYNOS) {
+               con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
                con |= pdata->noise_cancel_mode <<
EXYNOS_TMU_TRIP_MODE_SHIFT;
                con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
        }
@@ -665,7 +674,6 @@ static void exynos_tmu_control(struct platform_device
*pdev, bool on)
                        pdata->trigger_level1_en << 4 |
                        pdata->trigger_level0_en;
        } else {
-               con |= EXYNOS_TMU_CORE_OFF;
                interrupt_en = 0; /* Disable all interrupts */
        }
        writel(interrupt_en, data->base + EXYNOS_TMU_REG_INTEN);
--
1.7.4.1

