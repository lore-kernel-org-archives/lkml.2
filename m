Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1GALvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:51:18 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:48596 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab1GALvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:51:17 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: plat-nand: Fixup kerneldoc for struct platform_nand_chip
Date: Fri,  1 Jul 2011 13:51:15 +0200
Message-Id: <1309521075-18106-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.5.4
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.7.1.113614
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_900_999 0, __ANY_URI 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The set_parts and priv members of struct platform_nand_chip where
removed in commit c36a6ef3845262ade529afb9f458738b1f196f83 but the
kerneldoc wasn't updated.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 include/linux/mtd/nand.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 38a2fb6..6060f49 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -605,8 +605,6 @@ extern int nand_do_read(struct mtd_info *mtd, loff_t from, size_t len,
  * @options:		Option flags, e.g. 16bit buswidth
  * @ecclayout:		ECC layout info structure
  * @part_probe_types:	NULL-terminated array of probe types
- * @set_parts:		platform specific function to set partitions
- * @priv:		hardware controller specific settings
  */
 struct platform_nand_chip {
 	int nr_chips;
-- 
1.7.5.4

