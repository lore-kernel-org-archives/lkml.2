Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1K1PtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:49:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1K1Pm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:42:59 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 09/11] checkpatch: fix complex macros handling of square brackets
Date: Mon, 28 Nov 2011 15:42:51 +0000
Message-Id: <1322494973-29225-10-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322494973-29225-1-git-send-email-apw@canonical.com>
References: <1322494973-29225-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 52507f6..71655dc 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2833,7 +2833,7 @@ sub process {
 			# Flatten any parentheses and braces
 			while ($dstat =~ s/\([^\(\)]*\)/1/ ||
 			       $dstat =~ s/\{[^\{\}]*\}/1/ ||
-			       $dstat =~ s/\[[^\{\}]*\]/1/)
+			       $dstat =~ s/\[[^\[\]]*\]/1/)
 			{
 			}
 
-- 
1.7.5.4

