Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1C2XFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:05:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45590 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1C2XFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:05:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6300"; a="82812993"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: davidb@codeaurora.org, bryanh@codeaurora.org, linux@arm.linux.org.uk,
        dwalker@fifo99.com
Cc: dima@android.com, Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] msm: gpio: Mark the msm_gpiomux_config strucutres as static
Date: Tue, 29 Mar 2011 16:04:28 -0700
Message-Id: <1301439868-22295-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The msm_gpiomux_config structures are now part of the board file
and can be marked as static

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/board-msm7x27.c |    2 +-
 arch/arm/mach-msm/board-msm7x30.c |    2 +-
 arch/arm/mach-msm/board-msm8x60.c |    2 +-
 arch/arm/mach-msm/board-qsd8x50.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm7x27.c b/arch/arm/mach-msm/board-msm7x27.c
index 10affe5..c008323 100644
--- a/arch/arm/mach-msm/board-msm7x27.c
+++ b/arch/arm/mach-msm/board-msm7x27.c
@@ -45,7 +45,7 @@
 #include "socinfo.h"
 #include "clock.h"
 
-struct msm_gpiomux_config msm7x27_gpiomux_configs[NR_GPIO_IRQS] __initdata = {};
+static struct msm_gpiomux_config msm7x27_gpiomux_configs[NR_GPIO_IRQS] = {};
 
 static struct resource smc91x_resources[] = {
 	[0] = {
diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index 2cd8e9a..2b4457a 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -60,7 +60,7 @@ static struct msm_otg_platform_data msm_otg_pdata = {
 	.otg_control		= OTG_PHY_CONTROL,
 };
 
-struct msm_gpiomux_config msm7x30_uart2_configs[] __initdata = {
+static struct msm_gpiomux_config msm7x30_uart2_configs[] = {
 	{
 		.gpio = 49, /* UART2 RFR */
 		.settings = {
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index de4d8d1..56d7470 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -29,7 +29,7 @@
 #include <mach/msm_iomap.h>
 #include "gpiomux.h"
 
-struct msm_gpiomux_config msm8x60_gpiomux_configs[NR_GPIO_IRQS] __initdata = {};
+static struct msm_gpiomux_config msm8x60_gpiomux_configs[NR_GPIO_IRQS] = {};
 
 static int __init gpiomux_init(void)
 {
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index 83ccc0f..d65a676 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -47,7 +47,7 @@ static struct gpiomux_setting uart3_suspended = {
 
 extern struct sys_timer msm_timer;
 
-struct msm_gpiomux_config qsd8x50_uart3_configs[] = {
+static struct msm_gpiomux_config qsd8x50_uart3_configs[] = {
 	{
 		.gpio = 86, /* UART3 RX */
 		.settings = {
-- 
Sent by an employee of the Qualcomm Innovation Center,Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

