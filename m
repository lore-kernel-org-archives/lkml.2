Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2GGMGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 08:06:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51955 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2GGMFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 08:05:34 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/8] staging/ft1000: fix the spaces issue at the start of line
Date: Sat,  7 Jul 2012 17:35:13 +0530
Message-Id: <1341662719-25752-2-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
References: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warns fixed

drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:2032: ERROR: code indent should use tabs where possible
drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:2032: WARNING: please, no spaces at the start of a line

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 0bd080c..c709671 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -2029,7 +2029,7 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 	ft1000_write_reg(dev, FT1000_REG_SUP_ISR, tempword);
 
         // Read interrupt type
-        inttype = ft1000_read_reg (dev, FT1000_REG_SUP_ISR);
+		inttype = ft1000_read_reg (dev, FT1000_REG_SUP_ISR);
         DEBUG(1,"ft1000_hw: interrupt status register after clear = 0x%x\n",inttype);
     }
 	ft1000_enable_interrupts(dev);
-- 
1.7.9.5

