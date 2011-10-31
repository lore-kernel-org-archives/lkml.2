Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1JaTuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:50:55 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:45349 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1JaTuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:50:54 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] fat: Spelling s/obsolate/obsolete/g
Date: Mon, 31 Oct 2011 20:50:45 +0100
Message-Id: <1320090645-17095-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/fat/inode.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 1726d73..66cec01 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -898,7 +898,7 @@ enum {
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
-	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
+	Opt_obsolete, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
 	Opt_err_panic, Opt_err_ro, Opt_discard, Opt_err,
 };
 
@@ -928,17 +928,17 @@ static const match_table_t fat_tokens = {
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
 	{Opt_discard, "discard"},
-	{Opt_obsolate, "conv=binary"},
-	{Opt_obsolate, "conv=text"},
-	{Opt_obsolate, "conv=auto"},
-	{Opt_obsolate, "conv=b"},
-	{Opt_obsolate, "conv=t"},
-	{Opt_obsolate, "conv=a"},
-	{Opt_obsolate, "fat=%u"},
-	{Opt_obsolate, "blocksize=%u"},
-	{Opt_obsolate, "cvf_format=%20s"},
-	{Opt_obsolate, "cvf_options=%100s"},
-	{Opt_obsolate, "posix"},
+	{Opt_obsolete, "conv=binary"},
+	{Opt_obsolete, "conv=text"},
+	{Opt_obsolete, "conv=auto"},
+	{Opt_obsolete, "conv=b"},
+	{Opt_obsolete, "conv=t"},
+	{Opt_obsolete, "conv=a"},
+	{Opt_obsolete, "fat=%u"},
+	{Opt_obsolete, "blocksize=%u"},
+	{Opt_obsolete, "cvf_format=%20s"},
+	{Opt_obsolete, "cvf_options=%100s"},
+	{Opt_obsolete, "posix"},
 	{Opt_err, NULL},
 };
 static const match_table_t msdos_tokens = {
@@ -1170,7 +1170,7 @@ static int parse_options(struct super_block *sb, char *options, int is_vfat,
 			break;
 
 		/* obsolete mount options */
-		case Opt_obsolate:
+		case Opt_obsolete:
 			fat_msg(sb, KERN_INFO, "\"%s\" option is obsolete, "
 			       "not supported now", p);
 			break;
-- 
1.7.0.4

