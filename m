Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1JKSZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:25:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab1JKSZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:25:15 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_ali: fix "Satelite" typo
Date: Tue, 11 Oct 2011 19:40:58 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110111940.59158.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_ali: fix "Satelite" typo

Cosmetic fix but thanks to it pata_ali's DMI table now matches
alim15x3's one.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_ali.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_ali.c
===================================================================
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -56,7 +56,7 @@ static const struct dmi_system_id cable_
 		},
 	},
 	{
-		.ident = "Toshiba Satelite S1800-814",
+		.ident = "Toshiba Satellite S1800-814",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "S1800-814"),
