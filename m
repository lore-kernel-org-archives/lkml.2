Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab0GUPjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:39:37 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50418 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab0GUPje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:39:34 -0400
From: Ameya Palande <ameya.palande@nokia.com>
To: len.brown@intel.com
Cc: linux-kernel@vger.kernel.org, ameya.palande@nokia.com
Subject: [PATCH] cpuidle: Remove references to ACPI
Date: Wed, 21 Jul 2010 18:39:26 +0300
Message-Id: <1279726766-19450-1-git-send-email-ameya.palande@nokia.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 21 Jul 2010 15:39:26.0502 (UTC) FILETIME=[E6836460:01CB28EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since cpuidle is generic framework and ACPI doesn't exist for non-x86
platforms, remove references to ACPI from Kconfig.

Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
---
 drivers/cpuidle/Kconfig |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index 7dbc4a8..512d25a 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -1,14 +1,11 @@
-
 config CPU_IDLE
 	bool "CPU idle PM support"
-	default ACPI
+	default PM
 	help
 	  CPU idle is a generic framework for supporting software-controlled
 	  idle processor power management.  It includes modular cross-platform
 	  governors that can be swapped during runtime.
 
-	  If you're using an ACPI-enabled platform, you should say Y here.
-
 config CPU_IDLE_GOV_LADDER
 	bool
 	depends on CPU_IDLE
-- 
1.7.0.4

