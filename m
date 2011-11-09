Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab1KIAUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:20:54 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:44150 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab1KIAUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:20:54 -0500
Subject: [PATCH] [TRIVIAL] mtd: drop select of MTD_PARTITIONS
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 01:20:52 +0100
Message-ID: <1320798052.14409.422.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MTD_PARTITIONS got killed in commit 6a8a98b22b. This means that since
v3.0 this Kconfig symbol doesn't exist anymore. Apparently selecting
a non-existant symbol is a nop. Drop that select.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Once again untested.

 drivers/mtd/nand/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index cce7b70..dd02792 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -420,7 +420,6 @@ config MTD_NAND_NANDSIM
 config MTD_NAND_GPMI_NAND
         bool "GPMI NAND Flash Controller driver"
         depends on MTD_NAND && (SOC_IMX23 || SOC_IMX28)
-	select MTD_PARTITIONS
 	select MTD_CMDLINE_PARTS
         help
 	 Enables NAND Flash support for IMX23 or IMX28.
-- 
1.7.4.4



