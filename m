Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab1FVSmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:42:15 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:58358 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757970Ab1FVSmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:42:13 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [12/15] staging: ft1000-pcmcia: delete unused DPRAM_BLK typedefs
Date: Wed, 22 Jun 2011 20:42:05 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106222042.07508.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused DPRAM_BLK typedefs.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

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
