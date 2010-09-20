Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0ITGe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 02:34:27 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:43069 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab0ITGeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 02:34:25 -0400
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Documentation/kbuild: correct variable definitions in makefiles.txt
Date: Sun, 19 Sep 2010 23:33:32 -0700
Message-Id: <1284964412-32211-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change $(src) and $(obj) definitions to state the path as absolute and
not relative.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---

Hmm, this file is also _full_ of bad grammar and might be out of date FAIK.
If you would like it updated/corrected, please let me know. I don't mind doing
this, but only if it is beneficial and wanted.

 Documentation/kbuild/makefiles.txt |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index c787ae5..fe162f5 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -376,14 +376,13 @@ more details, with real examples.
 	Two variables are used when defining special rules:
 
     $(src)
-	$(src) is a relative path which points to the directory
-	where the Makefile is located. Always use $(src) when
-	referring to files located in the src tree.
+	The absolute path to the directory where the makefile is
+	located. Always use $(src) when referring to files located
+	in the src directory.
 
     $(obj)
-	$(obj) is a relative path which points to the directory
-	where the target is saved. Always use $(obj) when
-	referring to generated files.
+	The absolute path to the directory where the target is saved.
+	Always use $(obj) when referring to generated files.
 
 	Example:
 		#drivers/scsi/Makefile
-- 
1.7.2.1

