Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1HLDVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 23:21:25 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:48998 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751975Ab1HLDVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 23:21:24 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hui Zhu <teawater@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Add missing WARN argument for min_t and max_t tests
Date: Thu, 11 Aug 2011 20:21:19 -0700
Message-Id: <c8bf994cb2ac9385debb1c40674c2c0e71886be5.1313118939.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hui Zhu <teawater@gmail.com>

From: Hui Zhu <teawater@gmail.com>

The test for bad uses of min_t and max_t is missing the --ignore type.
Add it.

Signed-off-by: Hui Zhu <teawater@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9d761c9..3dfc471 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2574,7 +2574,8 @@ sub process {
 				} else {
 					$cast = $cast2;
 				}
-				WARN("$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
+				WARN("MINMAX",
+				     "$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
 			}
 		}
 
-- 
1.7.6.405.gc1be0

