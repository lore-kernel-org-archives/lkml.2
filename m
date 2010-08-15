Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab0HOFWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:22:21 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:64845 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0HOFWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:22:20 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 4/5] intel_idle: no longer EXPERIMENTAL
Date: Sun, 15 Aug 2010 01:22:04 -0400
Message-id: <5a5e28daea69652505ac07eb5fbda4d7f0534926.1281849655.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.2.1.95.g3d045
In-reply-to: <1281849725-7379-1-git-send-email-lenb@kernel.org>
References: <1281849725-7379-1-git-send-email-lenb@kernel.org>
In-reply-to: <0394c6676e3fa48587fbe4821390d3264672c530.1281849655.git.len.brown@intel.com>
References: <0394c6676e3fa48587fbe4821390d3264672c530.1281849655.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

This is a fully supported driver.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/Kconfig b/drivers/idle/Kconfig
index 82e4e86..8489eb5 100644
--- a/drivers/idle/Kconfig
+++ b/drivers/idle/Kconfig
@@ -3,7 +3,6 @@ config INTEL_IDLE
 	depends on CPU_IDLE
 	depends on X86
 	depends on CPU_SUP_INTEL
-	depends on EXPERIMENTAL
 	help
 	  Enable intel_idle, a cpuidle driver that includes knowledge of
 	  native Intel hardware idle features.  The acpi_idle driver
-- 
1.7.2.1.95.g3d045

