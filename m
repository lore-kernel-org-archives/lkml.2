Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1E3IXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:23:32 -0400
Received: from narfation.org ([79.140.41.39]:44579 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab1E3IXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:23:31 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH-resend] checkpatch: add __rcu as a sparse modifier
Date: Mon, 30 May 2011 10:22:54 +0200
Message-Id: <1306743774-3847-1-git-send-email-sven@narfation.org>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1304848485-14219-1-git-send-email-sven@narfation.org>
References: <1304848485-14219-1-git-send-email-sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "need consistent spacing around '*'" error after a __rcu sparse
annotation which was caused by the missing __rcu entry in the
checkpatch.pl internal list of sparse keywords.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Andy Whitcroft <apw@canonical.com>
---
I reported that problem 2 1/2 months ago and then send the patch 3 weeks
ago, but never got a reaction. Therefore I resend the patch to Andrew
Morton instead of Andy Whitcroft. He seems to have been responsible for
the last checkpatch.pl-patches.

Btw. thanks Eric Dumazet for the Acked-by.

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
1.7.5.3

