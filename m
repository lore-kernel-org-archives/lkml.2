Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2HNTcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:32:13 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:39113 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2HNTcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:32:11 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2012 15:32:11 EDT
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Subject: [PATCH] mtd: m25p80: add support for Micron N25Q256A
Date: Tue, 14 Aug 2012 15:24:07 -0400
Message-Id: <1344972247-23583-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The manufacturer datasheet can be found on the Micron website,
under the name n25q_256mb_3v_65nm.pdf:

http://www.micron.com/search?source=ps&q=n25q_256mb_3v_65nm

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 drivers/mtd/devices/m25p80.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 9f9982f..0a23f23 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -686,6 +686,9 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "mx25l25635e", INFO(0xc22019, 0, 64 * 1024, 512, 0) },
 	{ "mx25l25655e", INFO(0xc22619, 0, 64 * 1024, 512, 0) },
 
+	/* Micron */
+	{ "n25q256a", INFO(0x20ba19, 0, 64 * 1024, 512, SECT_4K) },
+
 	/* Spansion -- single (large) sector size only, at least
 	 * for the chips listed here (without boot sectors).
 	 */
-- 
1.7.11.2

