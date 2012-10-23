Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab2JWU3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:29:04 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43665 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964861Ab2JWUGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:06:02 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 122/193] drivers/scsi/device_handler: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:15 -0700
Message-Id: <1351022666-6960-123-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

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

