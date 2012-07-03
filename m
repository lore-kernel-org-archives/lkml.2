Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab2GCBXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:23:53 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58667 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab2GCBXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:23:51 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH] Documentation: Add rights of maintainers to carry Acked-by forward
Date: Mon,  2 Jul 2012 21:23:18 -0400
Message-Id: <1341278598-8554-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.7.7.6
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In writing patches, we occasionally hit a snag when, after a subsystem
maintainer provides an Acked-by: on a patch, the tree maintainer may asked for
further changes to a patch.  When this occurs, the tree maintainer often feels
like they need to wait for a new ack from the subsystem maintainer again, a
process which can cause unneeded delays.  This patch add language that
explicitly confers authority on the upstream maintainer the right to carry acks
forward if subsequent revisions do not signigicantly impact the functionality of
the patch.  This should reduce latency and burden on subtree maintainers when
getting last minute post-review cleanups done on patches.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Rob Landley <rob@landley.net>
CC: linux-doc@vger.kernel.org
---
 Documentation/SubmittingPatches |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index c379a2a..e2000ec 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -414,6 +414,16 @@ the part which affects that maintainer's code.  Judgement should be used here.
 When in doubt people should refer to the original discussion in the mailing
 list archives.
 
+Note that an Acked-by: From a subsystem maintainer on a given patch confers
+upon the tree maintainer integrating the patch the authority to carry those Acks
+forward through subsequent versions of a patch, as long as those versions do not
+significantly impact the functionality of the patch.  For example, say the isdn
+subsystem maintainer sends an Acked-by: on version 1 of a patch bound for the
+networking tree.  The networking maintainer then requests that some comments in
+the code be modified to comply with the CodingStyle document.  The networking
+tree maintanier may reapply the subsystem maintainers Acked-by: to the new
+version as no significant changes were made to the patch functionality.
+
 If a person has had the opportunity to comment on a patch, but has not
 provided such comments, you may optionally add a "Cc:" tag to the patch.
 This is the only tag which might be added without an explicit action by the
-- 
1.7.7.6

