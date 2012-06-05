Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab2FEPhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:37:12 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:45334 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751037Ab2FEPhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:37:10 -0400
From: Federico Fuga <fuga@studiofuga.com>
Cc: fuga@studiofuga.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MTD: add JEDEC ID for w25q32dw to chip table
Date: Tue,  5 Jun 2012 17:37:01 +0200
Message-Id: <1338910621-3843-1-git-send-email-fuga@studiofuga.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1338900917.2507.50.camel@sauron.fi.intel.com>
References: <1338900917.2507.50.camel@sauron.fi.intel.com>
X-Identified-User: {2354:box484.bluehost.com:happycac:studiofuga.com} {sentby:smtp auth 95.241.194.105 authed with fuga+studiofuga.com}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "ing. Federico Fuga" <fuga@studiofuga.com>

Adds JEDEC ID for the 1.8V version of WinBond w25q32

Signed-off-by: Federico Fuga <fuga@studiofuga.com>
---
 drivers/mtd/devices/m25p80.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 7c60ddd..9d16890 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -757,6 +757,7 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "w25x16", INFO(0xef3015, 0, 64 * 1024,  32, SECT_4K) },
 	{ "w25x32", INFO(0xef3016, 0, 64 * 1024,  64, SECT_4K) },
 	{ "w25q32", INFO(0xef4016, 0, 64 * 1024,  64, SECT_4K) },
+	{ "w25q32dw", INFO(0xef6016, 0, 64 * 1024,  64, SECT_4K) },
 	{ "w25x64", INFO(0xef3017, 0, 64 * 1024, 128, SECT_4K) },
 	{ "w25q64", INFO(0xef4017, 0, 64 * 1024, 128, SECT_4K) },
 
-- 
1.7.9.5

