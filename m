Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0GUEwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:52:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45814 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0GUEva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lYpbDlVn66w2F0QQ+9Va/qduRa20/vnm/9+rguKmE3unMhDfhTwkzEULQhdIDLOWE+
         gwzG3Pk1zaO9ul/2v6R7bAyopTB/2HiRB/edxRjdSYPQ7NIEYCDiSRV6lMlaS8DdLdOk
         ISyAJ8Sxgaw5wfGPpOjzN32Lvt02uHjCWgrCc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 14/14]Documentation/arm/SA1100/Assabet update web addresses.
Date: Tue, 20 Jul 2010 21:51:00 -0700
Message-Id: <1279687861-29282-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address to the company
site due to me being unable to locate the original info,
and also updates a web address to the new location.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/arm/SA1100/Assabet |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm/SA1100/Assabet b/Documentation/arm/SA1100/Assabet
index 91f7ce7..08b885d 100644
--- a/Documentation/arm/SA1100/Assabet
+++ b/Documentation/arm/SA1100/Assabet
@@ -2,8 +2,7 @@ The Intel Assabet (SA-1110 evaluation) board
 ============================================
 
 Please see:
-http://developer.intel.com/design/strong/quicklist/eval-plat/sa-1110.htm
-http://developer.intel.com/design/strong/guides/278278.htm
+http://developer.intel.com
 
 Also some notes from John G Dorsey <jd5q@andrew.cmu.edu>:
 http://www.cs.cmu.edu/~wearable/software/assabet.html
@@ -64,7 +63,7 @@ Initial RedBoot configuration
 -----------------------------
 
 The commands used here are explained in The RedBoot User's Guide available
-on-line at http://sources.redhat.com/ecos/docs-latest/redboot/redboot.html.
+on-line at http://sources.redhat.com/ecos/docs.html.
 Please refer to it for explanations.
 
 If you have a CF network card (my Assabet kit contained a CF+ LP-E from
-- 
1.7.1.rc1.21.gf3bd6

