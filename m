Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1CPVMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:12:53 -0400
Received: from kroah.org ([198.145.64.141]:42616 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279Ab1CPVLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ferenc Wagner <wferi@niif.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/50] sysfs: Capitalize description of SYSFS_DEPRECATED{_V2} options
Date: Wed, 16 Mar 2011 14:10:57 -0700
Message-Id: <1300309888-5028-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ferenc Wagner <wferi@niif.hu>

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 init/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index be788c0..e72fd10 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -814,7 +814,7 @@ config MM_OWNER
 	bool
 
 config SYSFS_DEPRECATED
-	bool "enable deprecated sysfs features to support old userspace tools"
+	bool "Enable deprecated sysfs features to support old userspace tools"
 	depends on SYSFS
 	default n
 	help
@@ -837,7 +837,7 @@ config SYSFS_DEPRECATED
 	  need to say Y here.
 
 config SYSFS_DEPRECATED_V2
-	bool "enabled deprecated sysfs features by default"
+	bool "Enable deprecated sysfs features by default"
 	default n
 	depends on SYSFS
 	depends on SYSFS_DEPRECATED
-- 
1.7.4.1

