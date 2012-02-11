Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab2BKMrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 07:47:21 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:46775
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755040Ab2BKMrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 07:47:20 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: standby24x7@gmail.com
Subject: [PATCH] [trivial] tools: Fix typo in ktest.pl
Date: Sat, 11 Feb 2012 21:46:56 +0900
Message-Id: <1328964416-2520-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "faied" to "failed" in
tools/testing/ktest/ktest.pl

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 62a134d..00c75c4 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2601,7 +2601,7 @@ sub config_bisect {
     # read directly what we want to check
     my %config_check;
     open (IN, $output_config)
-	or dodie "faied to open $output_config";
+	or dodie "failed to open $output_config";
 
     while (<IN>) {
 	if (/^((CONFIG\S*)=.*)/) {
-- 
1.7.6.5

