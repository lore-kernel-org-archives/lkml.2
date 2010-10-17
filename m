Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0JQIDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 04:03:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47324 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab0JQIDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 04:03:19 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: allow single space before labels
Date: Sun, 17 Oct 2010 04:05:37 -0400
Message-Id: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..1d06df7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1459,7 +1459,7 @@ sub process {
 		}
 
 # check for spaces at the beginning of a line.
-		if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/)  {
+		if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/ && $rawline !~ /:$/)  {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			WARN("please, no space for starting a line, \
 				excluding comments\n" . $herevet);
-- 
1.7.3.1

