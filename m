Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab2KEXOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:14:32 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59441 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab2KEXFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:32 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 075/104] drivers/scsi/device_handler: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:32 -0800
Message-Id: <1352156701-4038-76-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/device_handler/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/Kconfig b/drivers/scsi/device_handler/Kconfig
index 6707025..69abd0a 100644
--- a/drivers/scsi/device_handler/Kconfig
+++ b/drivers/scsi/device_handler/Kconfig
@@ -32,8 +32,8 @@ config SCSI_DH_EMC
 	If you have a EMC CLARiiON select y. Otherwise, say N.
 
 config SCSI_DH_ALUA
-	tristate "SPC-3 ALUA Device Handler (EXPERIMENTAL)"
-	depends on SCSI_DH && EXPERIMENTAL
+	tristate "SPC-3 ALUA Device Handler"
+	depends on SCSI_DH
 	help
 	  SCSI Device handler for generic SPC-3 Asymmetric Logical Unit
 	  Access (ALUA).
-- 
1.7.9.5

