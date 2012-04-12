Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2DRAVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:21:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14961 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab2DRAVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:21:22 -0400
Message-Id: <6e201a$5e4iug@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6684"; a="182602704"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Thu, 12 Apr 2012 15:57:33 -0500
Subject: [PATCH 10/10] hexagon: add missing cpu.h include
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/kernel/smp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index 0672463..1298141 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -1,7 +1,7 @@
 /*
  * SMP support for Hexagon
  *
- * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2010-2012, Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/spinlock.h>
+#include <linux/cpu.h>
 
 #include <asm/time.h>    /*  timer_interrupt  */
 #include <asm/hexagon_vm.h>
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
