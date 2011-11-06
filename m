Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1KFCgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 22:36:36 -0400
Received: from que31.charter.net ([209.225.8.23]:34295 "EHLO que31.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1KFCge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 22:36:34 -0400
X-Greylist: delayed 1457 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Nov 2011 22:36:34 EDT
X-Authority-Analysis: v=1.1 cv=CKBBFOpPYfBSFfEY1Rl9efxuAv/fdt7oFsWUUq3BrLQ=
 c=1 sm=1 a=Xu-_4Nhev_YA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=V7_HE7xjge1DeOynhJwA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Gregory.Dietsche@cuw.edu
To: julia@diku.dk, mmarek@suse.cz
Cc: rdunlap@xenotime.net, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        cocci@diku.dk, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [RESEND 2/2] coccinelle.txt: update documentation to include M= option
Date: Sat,  5 Nov 2011 20:59:44 -0500
Message-Id: <1320544784-24576-3-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320544784-24576-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1320544784-24576-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

Adding documentation for the new M= option which limits Coccinelle
to a specific set of directories.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 Documentation/coccinelle.txt |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
index 96b6903..cf44eb6 100644
--- a/Documentation/coccinelle.txt
+++ b/Documentation/coccinelle.txt
@@ -102,9 +102,15 @@ or
 	make coccicheck COCCI=<my_SP.cocci> MODE=report
 
 
- Using Coccinelle on (modified) files
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ Controlling Which Files are Processed by Coccinelle
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+By default the entire kernel source tree is checked.
+
+To apply Coccinelle to a specific directory, M= can be used.
+For example, to check drivers/net/wireless/ one may write:
 
+    make coccicheck M=drivers/net/wireless/
+    
 To apply Coccinelle on a file basis, instead of a directory basis, the
 following command may be used:
 
-- 
1.7.6.4

