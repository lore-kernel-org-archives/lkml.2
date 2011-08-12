Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1HLQWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:22:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37368 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1HLQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:22:05 -0400
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH] scripts: get_maintainer: Update Linus' git repository
Date: Fri, 12 Aug 2011 18:21:55 +0200
Message-Id: <1313166115-2838-1-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to new git tree -
(git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git).

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index eb2f1e6..4594f33 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -1389,7 +1389,7 @@ sub vcs_exists {
 	warn("$P: No supported VCS found.  Add --nogit to options?\n");
 	warn("Using a git repository produces better results.\n");
 	warn("Try Linus Torvalds' latest git repository using:\n");
-	warn("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
+	warn("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git\n");
 	$printed_novcs = 1;
     }
     return 0;
-- 
1.7.6

