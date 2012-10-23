Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965476Ab2JWVCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:02:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43414 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933705Ab2JWUFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:14 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 086/193] drivers/net/ethernet/packetengines: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:39 -0700
Message-Id: <1351022666-6960-87-git-send-email-keescook@chromium.org>
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

CC: Stephen Hemminger <shemminger@vyatta.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/packetengines/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/packetengines/Kconfig b/drivers/net/ethernet/packetengines/Kconfig
index 8f29feb..cbbeca3 100644
--- a/drivers/net/ethernet/packetengines/Kconfig
+++ b/drivers/net/ethernet/packetengines/Kconfig
@@ -32,8 +32,8 @@ config HAMACHI
 	  called hamachi.
 
 config YELLOWFIN
-	tristate "Packet Engines Yellowfin Gigabit-NIC support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Packet Engines Yellowfin Gigabit-NIC support"
+	depends on PCI
 	select CRC32
 	---help---
 	  Say Y here if you have a Packet Engines G-NIC PCI Gigabit Ethernet
-- 
1.7.9.5

