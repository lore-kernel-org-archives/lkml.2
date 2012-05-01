Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab2EACEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 22:04:10 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52038 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab2EACEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 22:04:09 -0400
From: Marek Vasut <marex@denx.de>
To: linux-mtd@lists.infradead.org
Cc: Marek Vasut <marex@denx.de>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] M25: Add support for Everspin MR25H256 MRAM chip
Date: Tue,  1 May 2012 04:04:00 +0200
Message-Id: <1335837840-15511-1-git-send-email-marex@denx.de>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This chip isn't JEDEC-compatible.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mtd/devices/m25p80.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 1924d24..85ce6fd 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -639,6 +639,9 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "en25q32b", INFO(0x1c3016, 0, 64 * 1024,  64, 0) },
 	{ "en25p64", INFO(0x1c2017, 0, 64 * 1024, 128, 0) },
 
+	/* Everspin */
+	{ "mr25h256", CAT25_INFO(  32 * 1024, 1, 256, 2) },
+
 	/* Intel/Numonyx -- xxxs33b */
 	{ "160s33b",  INFO(0x898911, 0, 64 * 1024,  32, 0) },
 	{ "320s33b",  INFO(0x898912, 0, 64 * 1024,  64, 0) },
-- 
1.7.10

