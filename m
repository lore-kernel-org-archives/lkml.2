Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2HaNS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:18:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53269 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2HaNS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:18:27 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: mcgrof@gmail.com
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 1/4] scripts/checkincludes.pl: Print usage with heredoc
Date: Fri, 31 Aug 2012 23:18:07 +1000
Message-Id: <1346419090-3808-2-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
References: <1346419090-3808-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is already used in checkpatch.pl, and is easier to
read, so I am changing it in checkincludes as well.

Additionally, this makes the usage output theoretically
easier to edit. In practise, there's almost no difference

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 scripts/checkincludes.pl |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
index 97b2c61..801ed5f 100755
--- a/scripts/checkincludes.pl
+++ b/scripts/checkincludes.pl
@@ -14,9 +14,13 @@
 use strict;
 
 sub usage {
-	print "Usage: checkincludes.pl [-r]\n";
-	print "By default we just warn of duplicates\n";
-	print "To remove duplicated includes in place use -r\n";
+	print <<EOM;
+Usage: checkincludes.pl [OPTIONS]... FILE...
+By default, we just warn of duplicates.
+
+Options:
+  -r                Remove duplicated includes in place
+EOM
 	exit 1;
 }
 
-- 
1.7.9.5

