Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab2HBTmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 15:42:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab2HBTmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 15:42:07 -0400
From: Peter Jones <pjones@redhat.com>
To: dhowells@redhat.com
Cc: jwboyer@redhat.com, linux-kernel@vger.kernel.org,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH] MODSIGN: Fix documentation of signed-nokey behavior when not enforcing.
Date: Thu,  2 Aug 2012 15:41:58 -0400
Message-Id: <1343936518-16362-1-git-send-email-pjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jwboyer's previous commit changes the behavior of module signing when
there's a valid signature but we don't know the public key and are in
permissive mode.  This updates the documentation to match.
---
 Documentation/module-signing.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
index d75d473..8c4bef9 100644
--- a/Documentation/module-signing.txt
+++ b/Documentation/module-signing.txt
@@ -185,7 +185,7 @@ This table indicates the behaviours of the various situations:
 	MODULE STATE				PERMISSIVE MODE	ENFORCING MODE
 	=======================================	===============	===============
 	Unsigned				Ok		EKEYREJECTED
-	Signed, no public key			ENOKEY		ENOKEY
+	Signed, no public key			Ok		ENOKEY
 	Validly signed, public key		Ok		Ok
 	Invalidly signed, public key		EKEYREJECTED	EKEYREJECTED
 	Validly signed, expired key		EKEYEXPIRED	EKEYEXPIRED
-- 
1.7.11.2

