Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab1EOKrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 06:47:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab1EOKp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 06:45:27 -0400
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se, tomas.winkler@intel.com,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 02/10] staging/mei: MEI Driver TODO list
Date: Sun, 15 May 2011 13:43:40 +0300
Message-Id: <1305456228-15265-3-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
References: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/staging/mei/TODO |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/mei/TODO

diff --git a/drivers/staging/mei/TODO b/drivers/staging/mei/TODO
new file mode 100644
index 0000000..3b6a667
--- /dev/null
+++ b/drivers/staging/mei/TODO
@@ -0,0 +1,17 @@
+TODO:
+	- Create in-kernel Client API. Examples of in-kernel clients are watchdog and AMTHI.
+	- ME Watchdog Driver to expose standard Linux watchdog interface
+	- Rewrite AMTHI to use in-kernel client interface
+	- Cleanup init and probe functions
+	- Review BUG/BUG_ON usage
+	- Cleanup and reorganize header files
+	- Rewrite client data structure
+	- Make state machine more readable
+	- Add mei.txt with driver explanation and it's driver
+	- Fix Kconfig
+	- Cleanup and split the timer function
+Upon Unstaging:
+	- move mei.h to include/linux/mei.h
+	- Documentation/ioctl/ioctl-number.txt
+	- drop mei_version.h
+	- Updated MAINTAINERS
-- 
1.7.1

