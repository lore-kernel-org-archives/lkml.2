Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab0JXViT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 17:38:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53329 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977Ab0JXViQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=jyW5M6lfrZCSc3V1Iylwu+6jkVmvfpy6lIF5s5S1UV2lSIoaKzldqBg3AaRV/5kMk8
         hl+kIva52dmX7w8bbrwSaWpeCTKUxb93wrh7f0DOREBo+MlQRs94qi0SJas1mGAp+BNP
         Pt/9vrkH7Btx4UXBnLJWPdM81D45wAM0BvKZ8=
From: Nicolas Palix <npalix.work@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Nicolas Palix <npalix.work@gmail.com>,
        Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Subject: [PATCH 3/4] Coccinelle: Fix documentation
Date: Sun, 24 Oct 2010 23:37:33 +0200
Message-Id: <1287956254-15563-3-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A file used as example has been moved elsewhere.
Update the documentation accordingly

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
Reported-by: Julia Lawall <julia@diku.dk>
---
 Documentation/coccinelle.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
index de51a3e..4a276ea 100644
--- a/Documentation/coccinelle.txt
+++ b/Documentation/coccinelle.txt
@@ -139,7 +139,7 @@ Example:
 
 Running
 
-	make coccicheck MODE=report COCCI=scripts/coccinelle/err_cast.cocci
+	make coccicheck MODE=report COCCI=scripts/coccinelle/api/err_cast.cocci
 
 will execute the following part of the SmPL script.
 
@@ -177,7 +177,7 @@ identified.
 Example:
 
 Running
-	make coccicheck MODE=patch COCCI=scripts/coccinelle/err_cast.cocci
+	make coccicheck MODE=patch COCCI=scripts/coccinelle/api/err_cast.cocci
 
 will execute the following part of the SmPL script.
 
@@ -221,7 +221,7 @@ NOTE: The diff-like output generated is NOT an applicable patch. The
 Example:
 
 Running
-	make coccicheck MODE=context COCCI=scripts/coccinelle/err_cast.cocci
+	make coccicheck MODE=context COCCI=scripts/coccinelle/api/err_cast.cocci
 
 will execute the following part of the SmPL script.
 
@@ -256,7 +256,7 @@ diff -u -p /home/user/linux/crypto/ctr.c /tmp/nothing
 Example:
 
 Running
-	make coccicheck MODE=org COCCI=scripts/coccinelle/err_cast.cocci
+	make coccicheck MODE=org COCCI=scripts/coccinelle/api/err_cast.cocci
 
 will execute the following part of the SmPL script.
 
-- 
1.7.0.4

