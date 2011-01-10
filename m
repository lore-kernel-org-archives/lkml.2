Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab1AJSEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:04:37 -0500
Received: from rs22.lvs.iif.hu ([193.225.14.172]:45225 "EHLO rs22.lvs.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab1AJSEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:04:36 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Andi Kleen <ak@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Cc: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH] Capitalize description of SYSFS_DEPRECATED{_V2} options
Date: Mon, 10 Jan 2011 19:04:22 +0100
Message-Id: <be17fee40f3056463861d70e5e89205bc144b781.1294682175.git.wferi@niif.hu>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 init/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 8dfd094..5166f43 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -811,7 +811,7 @@ config MM_OWNER
 	bool
 
 config SYSFS_DEPRECATED
-	bool "enable deprecated sysfs features to support old userspace tools"
+	bool "Enable deprecated sysfs features to support old userspace tools"
 	depends on SYSFS
 	default n
 	help
@@ -834,7 +834,7 @@ config SYSFS_DEPRECATED
 	  need to say Y here.
 
 config SYSFS_DEPRECATED_V2
-	bool "enabled deprecated sysfs features by default"
+	bool "Enable deprecated sysfs features by default"
 	default n
 	depends on SYSFS
 	depends on SYSFS_DEPRECATED
-- 
1.6.5

