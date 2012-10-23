Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965388Ab2JWUyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:54:25 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37935 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933749Ab2JWUFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:20 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jiri Slaby <jslaby@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 099/193] drivers/net/wan: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:52 -0700
Message-Id: <1351022666-6960-100-git-send-email-keescook@chromium.org>
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

CC: Lucas De Marchi <lucas.demarchi@profusion.mobi>
CC: Jiri Slaby <jslaby@suse.cz>
CC: "David S. Miller" <davem@davemloft.net>
CC: Takashi Iwai <tiwai@suse.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wan/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index d58431e..c0cd88d 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -375,7 +375,7 @@ config WAN_ROUTER_DRIVERS
 	  If unsure, say N.
 
 config CYCLADES_SYNC
-	tristate "Cyclom 2X(tm) cards (EXPERIMENTAL)"
+	tristate "Cyclom 2X(tm) cards"
 	depends on WAN_ROUTER_DRIVERS && (PCI || ISA)
 	---help---
 	  Cyclom 2X from Cyclades Corporation <http://www.avocent.com/> is an
@@ -403,7 +403,7 @@ config CYCLADES_SYNC
 	  module will be called cyclomx.
 
 config CYCLOMX_X25
-	bool "Cyclom 2X X.25 support (EXPERIMENTAL)"
+	bool "Cyclom 2X X.25 support"
 	depends on CYCLADES_SYNC
 	help
 	  Connect a Cyclom 2X card to an X.25 network.
@@ -412,7 +412,7 @@ config CYCLOMX_X25
 
 # X.25 network drivers
 config LAPBETHER
-	tristate "LAPB over Ethernet driver (EXPERIMENTAL)"
+	tristate "LAPB over Ethernet driver"
 	depends on LAPB && X25
 	---help---
 	  Driver for a pseudo device (typically called /dev/lapb0) which allows
@@ -428,7 +428,7 @@ config LAPBETHER
 	  If unsure, say N.
 
 config X25_ASY
-	tristate "X.25 async driver (EXPERIMENTAL)"
+	tristate "X.25 async driver"
 	depends on LAPB && X25
 	---help---
 	  Send and receive X.25 frames over regular asynchronous serial
-- 
1.7.9.5

