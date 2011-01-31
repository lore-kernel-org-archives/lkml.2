Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab1AaMBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:01:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:31232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab1AaMA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:00:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,404,1291622400"; 
   d="scan'208";a="702347035"
From: Tomas Winkler <tomas.winkler@intel.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] checkpatch.pl: be more specific about what is wrong with Kconfig help
Date: Mon, 31 Jan 2011 14:00:51 +0200
Message-Id: <1296475251-6470-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.3.5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

explain that Kconfig help paragraphs is expected to be at least 4 lines
long

Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 scripts/checkpatch.pl |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4c0383d..679122f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1452,7 +1452,9 @@ sub process {
 				}
 				$length++;
 			}
-			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_end && $length < 4);
+			if ($is_end && $length < 4) {
+				WARN("please write a paragraph that describes the config symbol fully, at least 4 lines\n" . $herecurr);
+			}
 			#print "is_end<$is_end> length<$length>\n";
 		}
 
-- 
1.7.3.5

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

