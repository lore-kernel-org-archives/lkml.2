Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964984Ab2JWUiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:38:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43607 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933825Ab2JWUFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:33 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Rodolfo Giometti <giometti@enneenne.com>
Subject: [PATCH 115/193] drivers/pps: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:08 -0700
Message-Id: <1351022666-6960-116-git-send-email-keescook@chromium.org>
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

