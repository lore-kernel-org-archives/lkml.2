Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1HVXH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:07:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62406 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab1HVXHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:07:25 -0400
From: Tom Lane <tom.lane0@gmail.com>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lane <tom.lane0@gmail.com>
Subject: [PATCH 2/2] Drivers: ata: sata_qstor: Fixed spaces after [ issues in sata_qstor.c
Date: Tue, 23 Aug 2011 00:06:11 +0100
Message-Id: <1314054371-4373-1-git-send-email-tom.lane0@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style errors in the sata_qstor driver, omitted one on line 538, fixing this one would hinder
readability of the code.

Signed-off-by: Tom Lane <tom.lane0@gmail.com>
---
 drivers/ata/sata_qstor.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 9d1a47b..5f36b5d 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -299,10 +299,10 @@ static void qs_qc_prep(struct ata_queued_cmd *qc)
 		dflags |= QS_DF_ELBA;

 	/* host control block (HCB) */
-	buf[ 0] = QS_HCB_HDR;
-	buf[ 1] = hflags;
-	*(__le32 *)(&buf[ 4]) = cpu_to_le32(qc->nbytes);
-	*(__le32 *)(&buf[ 8]) = cpu_to_le32(nelem);
+	buf[0] = QS_HCB_HDR;
+	buf[1] = hflags;
+	*(__le32 *)(&buf[4]) = cpu_to_le32(qc->nbytes);
+	*(__le32 *)(&buf[8]) = cpu_to_le32(nelem);
 	addr = ((u64)pp->pkt_dma) + QS_CPB_BYTES;
 	*(__le64 *)(&buf[16]) = cpu_to_le64(addr);

--
1.7.6

