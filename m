Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2ISHBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:01:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50941 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2ISHAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:00:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6839"; a="236147318"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 5/5] ARM: msm: Remove unused cpu.h header file
Date: Wed, 19 Sep 2012 00:00:44 -0700
Message-Id: <1348038044-1790-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.403.gce5cf6f
In-Reply-To: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
References: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header file is no longer used now that the msm timer.c and
the gpio driver have been made more runtime aware. Remove the
header file so no future users pop-up.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/cpu.h | 54 ------------------------------------
 1 file changed, 54 deletions(-)
 delete mode 100644 arch/arm/mach-msm/include/mach/cpu.h

diff --git a/arch/arm/mach-msm/include/mach/cpu.h b/arch/arm/mach-msm/include/mach/cpu.h
deleted file mode 100644
index a9481b0..0000000
--- a/arch/arm/mach-msm/include/mach/cpu.h
+++ /dev/null
@@ -1,54 +0,0 @@
-/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-
-#ifndef __ARCH_ARM_MACH_MSM_CPU_H__
-#define __ARCH_ARM_MACH_MSM_CPU_H__
-
-/* TODO: For now, only one CPU can be compiled at a time. */
-
-#define cpu_is_msm7x01()	0
-#define cpu_is_msm7x30()	0
-#define cpu_is_qsd8x50()	0
-#define cpu_is_msm8x60()	0
-#define cpu_is_msm8960()	0
-
-#ifdef CONFIG_ARCH_MSM7X00A
-# undef cpu_is_msm7x01
-# define cpu_is_msm7x01()	1
-#endif
-
-#ifdef CONFIG_ARCH_MSM7X30
-# undef cpu_is_msm7x30
-# define cpu_is_msm7x30()	1
-#endif
-
-#ifdef CONFIG_ARCH_QSD8X50
-# undef cpu_is_qsd8x50
-# define cpu_is_qsd8x50()	1
-#endif
-
-#ifdef CONFIG_ARCH_MSM8X60
-# undef cpu_is_msm8x60
-# define cpu_is_msm8x60()	1
-#endif
-
-#ifdef CONFIG_ARCH_MSM8960
-# undef cpu_is_msm8960
-# define cpu_is_msm8960()	1
-#endif
-
-#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

