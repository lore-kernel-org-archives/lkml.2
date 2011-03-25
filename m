Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1CYSsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:48:08 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2262 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1CYSsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:48:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6296"; a="81911512"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>
Subject: [PATCH] ARM: allow hotplug on msm
Date: Fri, 25 Mar 2011 11:47:41 -0700
Message-Id: <1301078861-1991-1-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hotplug support was added in 9f1890a (msm: hotplug: support cpu hotplug
on msm, 2010-12-02)

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 172e918..9485b6c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1358,7 +1358,6 @@ config NR_CPUS
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
 	depends on SMP && HOTPLUG && EXPERIMENTAL
-	depends on !ARCH_MSM
 	help
 	  Say Y here to experiment with turning CPUs off and on.  CPUs
 	  can be controlled through /sys/devices/system/cpu.
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

