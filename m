Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2GGMGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 08:06:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51955 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2GGMFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 08:05:55 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 6/8] staging/ft1000: fix the foo * bar warning
Date: Sat,  7 Jul 2012 17:35:17 +0530
Message-Id: <1341662719-25752-6-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
References: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 67ad7ee..9a5ba07 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -115,7 +115,7 @@ static inline u16 ft1000_read_fifo_len(struct net_device *dev)
 //     value  - value of dpram
 //
 //---------------------------------------------------------------------------
-u16 ft1000_read_dpram(struct net_device * dev, int offset)
+u16 ft1000_read_dpram(struct net_device *dev, int offset)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	unsigned long flags;
-- 
1.7.9.5

