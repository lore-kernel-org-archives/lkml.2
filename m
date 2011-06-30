Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1F3WGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:06:09 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:54382 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753321Ab1F3WES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:18 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/28] staging: ft1000-pcmcia: delete unused DPRAM_BLK typedefs
Date: Fri,  1 Jul 2011 00:03:43 +0200
Message-Id: <1309471437-12633-15-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused DPRAM_BLK typedefs.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index 5fc64f3..810038a 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -370,11 +370,6 @@ struct ft1000_info {
 	char netdevname[IFNAMSIZ];
 };
 
-typedef struct _DPRAM_BLK {
-    struct list_head list;
-    u16 *pbuffer;
-} __attribute__ ((packed)) DPRAM_BLK, *PDPRAM_BLK;
-
 extern u16 ft1000_read_dpram (struct net_device *dev, int offset);
 extern void card_bootload(struct net_device *dev);
 extern u16 ft1000_read_dpram_mag_16 (struct net_device *dev, int offset, int Index);
-- 
Ondrej Zary

