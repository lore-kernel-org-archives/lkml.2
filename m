Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1EHSEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:04:50 -0400
Received: from [69.28.251.93] ([69.28.251.93]:51334 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab1EHSEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:04:47 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: <dedekind@infradead.org>, <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] mtd: m25p80: Add Numonyx m25px32 family
Date: Sun, 08 May 2011 10:47:59 -0700
Message-Id: <657440bd74a74686279e691d39337f21@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/mtd/devices/m25p80.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 3fb981d..09c342d 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -729,7 +729,10 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "m25pe80", INFO(0x208014,  0, 64 * 1024, 16,       0) },
 	{ "m25pe16", INFO(0x208015,  0, 64 * 1024, 32, SECT_4K) },
 
-	{ "m25px64", INFO(0x207117,  0, 64 * 1024, 128, 0) },
+	{ "m25px32",    INFO(0x207116,  0, 64 * 1024, 64, SECT_4K) },
+	{ "m25px32-s0", INFO(0x207316,  0, 64 * 1024, 64, SECT_4K) },
+	{ "m25px32-s1", INFO(0x206316,  0, 64 * 1024, 64, SECT_4K) },
+	{ "m25px64",    INFO(0x207117,  0, 64 * 1024, 128, 0) },
 
 	/* Winbond -- w25x "blocks" are 64K, "sectors" are 4KiB */
 	{ "w25x10", INFO(0xef3011, 0, 64 * 1024,  2,  SECT_4K) },
-- 
1.7.5

