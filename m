Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab0JHT20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:28:26 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51050 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab0JHT2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:28:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NQprCFSIsH2a54OFNRKn7gy2kV+2HQXgCnLG4sKUDD54D2lfNlzFrRYez0O/dK2So6
         f2ZQosUmycJ0Jzm59spZJyXpTMrEID/qSFeZkyRM0HpjwBIwT4A2eKkm1R9oOFUkCbBl
         zI44yjNuLpPfFmsRUm4720qM9y5dvAPk6nmFA=
From: Nicolas Palix <npalix.work@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Nicolas Palix <npalix.work@gmail.com>,
        Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Subject: [PATCH 4/6] Coccinelle: Use new comment format to explain kfree.cocci
Date: Fri,  8 Oct 2010 21:27:39 +0200
Message-Id: <1286566061-17122-5-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
References: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new comment format to separate proposed commit message
and information about generated false positives

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

