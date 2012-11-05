Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab2KEXLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:11:44 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60637 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241Ab2KEXFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:36 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Rodolfo Giometti <giometti@enneenne.com>
Subject: [PATCH 071/104] drivers/pps: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:28 -0800
Message-Id: <1352156701-4038-72-git-send-email-keescook@chromium.org>
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

CC: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/pps/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 258ca59..982d16b 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -6,7 +6,6 @@ menu "PPS support"
 
 config PPS
 	tristate "PPS support"
-	depends on EXPERIMENTAL
 	---help---
 	  PPS (Pulse Per Second) is a special pulse provided by some GPS
 	  antennae. Userland can use it to get a high-precision time
-- 
1.7.9.5

