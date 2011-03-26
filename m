Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab1CZBoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:44:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46899 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932218Ab1CZBog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:44:36 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18L3fA3/iYLbSg8AFmVcr5yzNP5KLD95GSQKlNTIa
	1MU9sn8speHjQy
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 17/27] staging/sbe-2t3e3: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:44:01 +0100
Message-Id: <1301103851-16352-17-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
References: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a common spelling mistake in
drivers/staging/sbe-2t3e3.

WRONG -> RIGHT
writting -> writing

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/sbe-2t3e3/io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sbe-2t3e3/io.c b/drivers/staging/sbe-2t3e3/io.c
index b458ff0..467efbd 100644
--- a/drivers/staging/sbe-2t3e3/io.c
+++ b/drivers/staging/sbe-2t3e3/io.c
@@ -68,7 +68,7 @@ void bootrom_write(struct channel *channel, u32 reg, u32 val)
 	/* select BootROM address */
 	dc_write(addr, SBE_2T3E3_21143_REG_BOOT_ROM_PROGRAMMING_ADDRESS, reg & 0x3FFFF);
 
-	/* select writting to BootROM */
+	/* select writing to BootROM */
 	dc_write(addr, SBE_2T3E3_21143_REG_BOOT_ROM_SERIAL_ROM_AND_MII_MANAGEMENT,
 		 SBE_2T3E3_21143_VAL_WRITE_OPERATION |
 		 SBE_2T3E3_21143_VAL_BOOT_ROM_SELECT |
@@ -312,7 +312,7 @@ void exar7300_write(struct channel *channel, u32 reg, u32 val)
 	cpld_write_nolock(channel, SBE_2T3E3_CPLD_REG_SERIAL_CHIP_SELECT,
 			  cpld_val_map[SBE_2T3E3_CPLD_VAL_LIU_SELECT][channel->h.slot]);
 
-	/* select writting to Serial I/O Bus */
+	/* select writing to Serial I/O Bus */
 	dc_write(addr, SBE_2T3E3_21143_REG_BOOT_ROM_SERIAL_ROM_AND_MII_MANAGEMENT,
 		 SBE_2T3E3_21143_VAL_WRITE_OPERATION |
 		 SBE_2T3E3_21143_VAL_SERIAL_ROM_SELECT |
-- 
1.7.3.4

