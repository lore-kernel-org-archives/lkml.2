Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab2IZLld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:41:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab2IZLlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:41:32 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/checkpatch.pl: seperate mutiple results with black line
Date: Wed, 26 Sep 2012 19:41:23 +0800
Message-Id: <1348659683-9202-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 0 errors, 0 warnings, 14 lines checked

XXXX.patch has no obvious style problems and is ready for submission.
total: 0 errors, 0 warnings, 7 lines checked

XXXX.patch has no obvious style problems and is ready for submission.
total: 0 errors, 0 warnings, 25 lines checked

XXXX.patch has no obvious style problems and is ready for submission.

After:
total: 0 errors, 0 warnings, 14 lines checked
XXXX.patch has no obvious style problems and is ready for submission.

total: 0 errors, 0 warnings, 7 lines checked
XXXX.patch has no obvious style problems and is ready for submission.

total: 0 errors, 0 warnings, 25 lines checked
XXXX.patch has no obvious style problems and is ready for submission.

Also leave two blank lines after the error message if check fails.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ca05ba2..15d9f08 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3588,7 +3588,7 @@ sub process {
 		print "$filename " if ($summary_file);
 		print "total: $cnt_error errors, $cnt_warn warnings, " .
 			(($check)? "$cnt_chk checks, " : "") .
-			"$cnt_lines lines checked\n";
+			"$cnt_lines lines checked";
 		print "\n" if ($quiet == 0);
 	}
 
@@ -3617,7 +3617,7 @@ sub process {
 	}
 
 	if ($clean == 1 && $quiet == 0) {
-		print "$vname has no obvious style problems and is ready for submission.\n"
+		print "$vname has no obvious style problems and is ready for submission.\n\n"
 	}
 	if ($clean == 0 && $quiet == 0) {
 		print << "EOM";
@@ -3625,6 +3625,8 @@ $vname has style problems, please review.
 
 If any of these errors are false positives, please report
 them to the maintainer, see CHECKPATCH in MAINTAINERS.
+
+
 EOM
 	}
 
-- 
1.7.9.5

