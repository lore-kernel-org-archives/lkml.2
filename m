Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1EHJ4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 05:56:20 -0400
Received: from narfation.org ([79.140.41.39]:34194 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab1EHJ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 05:56:16 -0400
From: Sven Eckelmann <sven@narfation.org>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org, Sven Eckelmann <sven@narfation.org>
Subject: [PATCH] checkpatch: add __rcu as a sparse modifier
Date: Sun,  8 May 2011 11:54:45 +0200
Message-Id: <1304848485-14219-1-git-send-email-sven@narfation.org>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d867081..9dc3800 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -145,7 +145,8 @@ our $Sparse	= qr{
 			__must_check|
 			__init_refok|
 			__kprobes|
-			__ref
+			__ref|
+			__rcu
 		}x;
 
 # Notes to $Attribute:
-- 
1.7.5.1

