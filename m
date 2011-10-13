Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1JMNVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:21:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35111 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab1JMNU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:20:59 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [PATCH] piix: add new short cable IDs
Date: Thu, 13 Oct 2011 15:20:15 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131520.15650.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] piix: add new short cable IDs

Based on commits 6034734 ("ata_piix: Add new laptop short
cable IDs") and 760cdb7 ("ata_piix: Add new short cable ID")
for ata_piix.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
earlier references:
https://lkml.org/lkml/2010/1/29/168

 drivers/ide/piix.c |    3 +++
 1 file changed, 3 insertions(+)

Index: b/drivers/ide/piix.c
===================================================================
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -256,9 +256,12 @@ static const struct ich_laptop ich_lapto
 	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
 	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
+	{ 0x27DF, 0x1028, 0x02b0 },	/* ICH7 on unknown Dell */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
+	{ 0x27DF, 0x103C, 0x361a },	/* ICH7 on unkown HP  */
 	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
+	{ 0x27DF, 0x152D, 0x0778 },	/* ICH7 on unknown Intel */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on Acer Aspire 2023WLMi */
 	{ 0x24CA, 0x1025, 0x003d },	/* ICH4 on ACER TM290 */
 	{ 0x266F, 0x1025, 0x0066 },	/* ICH6 on ACER Aspire 1694WLMi */
