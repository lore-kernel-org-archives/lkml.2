Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1FHDaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:30:03 -0400
Received: from mta11.charter.net ([216.33.127.80]:50432 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1FHD36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:29:58 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=D9lZPAAIDQcA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=V7_HE7xjge1DeOynhJwA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: julia@diku.dk
Cc: rdunlap@xenotime.net, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        cocci@diku.dk, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 2/2] coccinelle.txt: update documentation to include M= option
Date: Tue,  7 Jun 2011 22:29:34 -0500
Message-Id: <1307503774-30370-3-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307503774-30370-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1307503774-30370-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.7.2.5

