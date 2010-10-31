Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab0JaUsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 16:48:51 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:56700 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0JaUst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 16:48:49 -0400
Date: Sun, 31 Oct 2010 21:48:47 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Joern Engel <joern@logfs.org>, Al Viro <viro@zeniv.linux.org.uk>
cc: logfs@logfs.org, Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] logfs: Add missing semicolon
Message-ID: <alpine.DEB.2.00.1010312146110.23385@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7d945a3aa7608f68dba04083d3421e0b43052660 ("logfs get_sb, part 3")
accidentally removed a semicolon, causing compile errors like:

fs/logfs/logfs.h:498: error: storage class specified for parameter ¡logfs_symlink_iops¢

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/logfs/logfs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/logfs/logfs.h b/fs/logfs/logfs.h
index cd51a36..57afd4a 100644
--- a/fs/logfs/logfs.h
+++ b/fs/logfs/logfs.h
@@ -486,7 +486,7 @@ static inline int logfs_get_sb_bdev(struct logfs_super *s,
 
 /* dev_mtd.c */
 #ifdef CONFIG_MTD
-int logfs_get_sb_mtd(struct logfs_super *s, int mtdnr)
+int logfs_get_sb_mtd(struct logfs_super *s, int mtdnr);
 #else
 static inline int logfs_get_sb_mtd(struct logfs_super *s, int mtdnr)
 {
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
