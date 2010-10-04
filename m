Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab0JDUtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:49:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65396 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308Ab0JDUtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=tYbDBCUG3H0CpX++Vg1XwoZVQ+EWVmF92tkEcrGKFbqfcZM11W5x1IKDJfyeYa/pOx
         qlk+P0R8F3DrQJLH3UXO5IxPL01qp42C0PUnYthm6O2jt6IO+1lnJ3hfo2RBSTSd7V6y
         2S35P4mKa5DcnmXqFpej/GYAiP86ovKir7zLk=
From: Nicolas Palix <npalix.work@gmail.com>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, Joerg Roedel <joerg.roedel@amd.com>,
        cocci@diku.dk, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] Coccinelle: Use new comment format to explain kfree.cocci
Date: Mon,  4 Oct 2010 22:48:38 +0200
Message-Id: <1286225320-22156-1-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new comment format to separate proposed commit message
and information about generated false positive

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/free/kfree.cocci |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/coccinelle/free/kfree.cocci b/scripts/coccinelle/free/kfree.cocci
index c13a539..f9f79d9 100644
--- a/scripts/coccinelle/free/kfree.cocci
+++ b/scripts/coccinelle/free/kfree.cocci
@@ -1,7 +1,8 @@
-/// Find a use after free.  Values of variables may imply that some
-/// execution paths are not possible, resulting in false positives.
-/// Another source of false positives are macros such as
-/// SCTP_DBG_OBJCNT_DEC that do not actually evaluate their argument
+/// Find a use after free.
+//# Values of variables may imply that some
+//# execution paths are not possible, resulting in false positives.
+//# Another source of false positives are macros such as
+//# SCTP_DBG_OBJCNT_DEC that do not actually evaluate their argument
 ///
 // Confidence: Moderate
 // Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
-- 
1.7.0.4

