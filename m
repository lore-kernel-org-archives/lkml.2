Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1ASD0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 22:26:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38752 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1ASD0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 22:26:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6230"; a="71034580"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 1/2] msm: Add name field to UART resources
Date: Tue, 18 Jan 2011 19:25:43 -0800
Message-Id: <1295407543-18352-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a name field to the I/O resources for the UARTs on MSM
targets in preparation for updates to the msm_serial
driver. The driver assumed there is one I/O resource per
UART, which is not the case on all targets.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/devices-msm7x00.c |    3 +++
 arch/arm/mach-msm/devices-msm7x30.c |    3 ++-
 arch/arm/mach-msm/devices-qsd8x50.c |    3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index fb548a8..2549fb2 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -38,6 +38,7 @@ static struct resource resources_uart1[] = {
 		.start	= MSM_UART1_PHYS,
 		.end	= MSM_UART1_PHYS + MSM_UART1_SIZE - 1,
 		.flags	= IORESOURCE_MEM,
+		.name  = "uart_resource"
 	},
 };

@@ -51,6 +52,7 @@ static struct resource resources_uart2[] = {
 		.start	= MSM_UART2_PHYS,
 		.end	= MSM_UART2_PHYS + MSM_UART2_SIZE - 1,
 		.flags	= IORESOURCE_MEM,
+		.name  = "uart_resource"
 	},
 };

@@ -64,6 +66,7 @@ static struct resource resources_uart3[] = {
 		.start	= MSM_UART3_PHYS,
 		.end	= MSM_UART3_PHYS + MSM_UART3_SIZE - 1,
 		.flags	= IORESOURCE_MEM,
+		.name  = "uart_resource"
 	},
 };

diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index 4e9a0ab..d4c7afc 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2008 Google, Inc.
- * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -41,6 +41,7 @@ static struct resource resources_uart2[] = {
 		.start	= MSM_UART2_PHYS,
 		.end	= MSM_UART2_PHYS + MSM_UART2_SIZE - 1,
 		.flags	= IORESOURCE_MEM,
+		.name  = "uart_resource"
 	},
 };

diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index a4b798f..93bddac 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2008 Google, Inc.
- * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -38,6 +38,7 @@ static struct resource resources_uart3[] = {
 		.start	= MSM_UART3_PHYS,
 		.end	= MSM_UART3_PHYS + MSM_UART3_SIZE - 1,
 		.flags	= IORESOURCE_MEM,
+		.name  = "uart_resource"
 	},
 };

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

