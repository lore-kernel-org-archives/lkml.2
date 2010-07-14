Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0GNSHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:07:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38459 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0GNSHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:07:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rnOJ+EMXzrbx4e83x8TKCCKiHi//MVLawbOy5EvmcGgnYQXuzU2HpoQW3RF9zedQDm
         318zxnX9BWfTClJbDdJtXgu8Vp49tg3QSQGq1p4Cv9C8YArSb+paqHhCI3ikBNEB57GA
         ABAcudLv2LVUrYAQPVnn9m0DoFU6ISgAMS/PU=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Thomas Mingarelli <Thomas.Mingarelli@hp.com>,
        dann frazier <dannf@hp.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] watchdog/hpwdt: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 22:06:30 +0400
Message-Id: <1279130790-19277-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/watchdog/hpwdt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index dbe650e..2056534 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -250,8 +250,8 @@ static int __devinit cru_detect(unsigned long map_entry,
 			physical_bios_offset);
 		printk(KERN_DEBUG "hpwdt: CRU Length:         0x%lx\n",
 			cru_length);
-		printk(KERN_DEBUG "hpwdt: CRU Mapped Address: 0x%x\n",
-			(unsigned int)&cru_rom_addr);
+		printk(KERN_DEBUG "hpwdt: CRU Mapped Address: %p\n",
+			&cru_rom_addr);
 	}
 	iounmap(bios32_map);
 	return retval;
-- 
1.7.0.4

