Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab2GZGxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 02:53:54 -0400
Received: from mail.nonattached.net ([193.160.39.60]:41593 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2GZGxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 02:53:52 -0400
From: Dan Luedtke <mail@danrl.de>
To: rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Cc: Dan Luedtke <mail@danrl.de>
Subject: [PATCH 2/3] scripts/kernel-doc: modern html -> html version 5
Date: Thu, 26 Jul 2012 08:52:32 +0200
Message-Id: <1343285553-14275-2-git-send-email-mail@danrl.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343285553-14275-1-git-send-email-mail@danrl.de>
References: <50103793.8000600@xenotime.net>
 <1343285553-14275-1-git-send-email-mail@danrl.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed non-timeless comment.

Signed-off-by: Dan Luedtke <mail@danrl.de>
---
 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index f85b278..1d3c779 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -189,7 +189,7 @@ my $local_lt = "\\\\\\\\lt:";
 my $local_gt = "\\\\\\\\gt:";
 my $blankline_html = $local_lt . "p" . $local_gt;	# was "<p>"
 
-# modern html
+# html version 5
 my %highlights_html5 = ( $type_constant, "<span class=\"const\">\$1</span>",
 			$type_func, "<span class=\"func\">\$1</span>",
 			$type_struct_xml, "<span class=\"struct\">\$1</span>",
-- 
1.7.10

