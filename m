Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab2JWUZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:25:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40558 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933976Ab2JWUK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:10:59 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Chris Boot <bootc@bootc.net>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 125/193] drivers/target/sbp: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:18 -0700
Message-Id: <1351022666-6960-126-git-send-email-keescook@chromium.org>
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

CC: Chris Boot <bootc@bootc.net>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/target/sbp/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/sbp/Kconfig b/drivers/target/sbp/Kconfig
index 132da54..1614bc7 100644
--- a/drivers/target/sbp/Kconfig
+++ b/drivers/target/sbp/Kconfig
@@ -1,6 +1,6 @@
 config SBP_TARGET
 	tristate "FireWire SBP-2 fabric module"
-	depends on FIREWIRE && EXPERIMENTAL
+	depends on FIREWIRE
 	help
 	  Say Y or M here to enable SCSI target functionality over FireWire.
 	  This enables you to expose SCSI devices to other nodes on the FireWire
-- 
1.7.9.5

