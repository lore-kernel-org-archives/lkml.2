Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1GSJBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 05:01:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40714 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab1GSJBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:01:32 -0400
Date: Tue, 19 Jul 2011 17:00:14 +0800
From: wangyanqing <udknight@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH]drivers:net:Kconfig
Message-ID: <20110719090014.GA5455@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Broadcom Tigon3 driver tg3.ko can't work without the Broadcom PHY,
 so maybe we should add a dependence on it.Or at least we should add
 notice in the help txt.

Signed-off-by: wang yanqing <udknight@gmail.com>
---
 drivers/net/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 93359fa..c2607cd 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2353,7 +2353,7 @@ config VIA_VELOCITY
 
 config TIGON3
 	tristate "Broadcom Tigon3 support"
-	depends on PCI
+	depends on PCI && BROADCOM_PHY
 	select PHYLIB
 	help
 	  This driver supports Broadcom Tigon3 based gigabit Ethernet cards.
-- 
1.7.3.4

