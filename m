Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab1JAUGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:06:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab1JAUFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH 14/26] mtd: nand_h1900 never worked
Date: Sat,  1 Oct 2011 22:03:46 +0200
Message-Id: <1317499438-14058-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:QaPI7IPm+YSKBYQjuoiwao9HBqI+r3lWvcK5rNFcngs
 iNlA2yYTRxGXwJe15s82TkrEYXMFmdwFrYAA9a0fEUFaNMdv0G
 pxywIwT4UJMJeDEZFQ6aYFwo9zVlmi0kDCrol1yvwkNdXUFhFp
 hx2sHvsO5Calk4akVu+w1HG2oaJV9B2iXiHrnQYUJWmjk9w1cu
 +uJKS8w/tIpPfyq+IEVePBcgCQGJPY0HI5U9x7X4fUdg+Lc/vY
 aAF+J28izdNwtcBTelBv5SIDg/9qEOLE9IuE2Nx+f9tjcCIqZZ
 cigcK16wXqt54vgmoKrG2dN2IfoF0CTYYOshrwBCIGgMQbr3uA
 xNWMmHZtrCGeOV0ZZu3ddVd8rnr6nj1jDAUXYSQoeoNk4affdo
 6JoF2OUdPaPGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been broken through all of git history and
cannot even be built. Better mark it as broken. Next stop is
removing from the tree.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>
---
 drivers/mtd/nand/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 4c342523..f85af18 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -92,7 +92,7 @@ config MTD_NAND_EDB7312
 
 config MTD_NAND_H1900
 	tristate "iPAQ H1900 flash"
-	depends on ARCH_PXA
+	depends on ARCH_PXA && BROKEN
 	help
 	  This enables the driver for the iPAQ h1900 flash.
 
-- 
1.7.5.4

