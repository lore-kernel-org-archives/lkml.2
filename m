Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab2JDRk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:40:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60386 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab2JDRkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:40:24 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: Wendy Liang <wendy.liang@petalogix.com>, Michal Simek <monstr@monstr.eu>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] mtd: m25p80: Add support for Numonyx N25Q128
Date: Thu,  4 Oct 2012 19:40:16 +0200
Message-Id: <1349372416-16925-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wendy Liang <wendy.liang@petalogix.com>

Add the id and sector mappings for SPI flash chips.

Signed-off-by: Wendy Liang <wendy.liang@petalogix.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: David Woodhouse <dwmw2@infradead.org>
CC: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
CC: Mike Frysinger <vapier@gentoo.org>
CC: linux-mtd@lists.infradead.org
---
 drivers/mtd/devices/m25p80.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 5d0d68c..cad89f1 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -722,6 +722,9 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "m25px32-s1", INFO(0x206316,  0, 64 * 1024, 64, SECT_4K) },
 	{ "m25px64",    INFO(0x207117,  0, 64 * 1024, 128, 0) },
 
+	/* Numonyx -- n25q */
+	{ "n25q128",    INFO(0x20ba18,  0, 64 * 1024, 256, 0) },
+
 	/* Winbond -- w25x "blocks" are 64K, "sectors" are 4KiB */
 	{ "w25x10", INFO(0xef3011, 0, 64 * 1024,  2,  SECT_4K) },
 	{ "w25x20", INFO(0xef3012, 0, 64 * 1024,  4,  SECT_4K) },
-- 
1.7.0.4

