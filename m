Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1IWPga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:36:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40041 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab1IWPg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:36:27 -0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: [PATCH] mtd/devices/m25p80: add support for at25df321a spi data flash
Date: Fri, 23 Sep 2011 19:36:18 +0400
Message-Id: <1316792178-5592-1-git-send-email-mikhail.kshevetskiy@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
---
 drivers/mtd/devices/m25p80.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 35180e4..12cfce7 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -661,6 +661,7 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "at25fs040",  INFO(0x1f6604, 0, 64 * 1024,   8, SECT_4K) },
 
 	{ "at25df041a", INFO(0x1f4401, 0, 64 * 1024,   8, SECT_4K) },
+	{ "at25df321a", INFO(0x1f4701, 0, 64 * 1024,  64, SECT_4K) },
 	{ "at25df641",  INFO(0x1f4800, 0, 64 * 1024, 128, SECT_4K) },
 
 	{ "at26f004",   INFO(0x1f0400, 0, 64 * 1024,  8, SECT_4K) },
-- 
1.7.5.4

