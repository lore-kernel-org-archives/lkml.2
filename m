Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab0FJKBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 06:01:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65147 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab0FJKBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 06:01:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Q6aFF4c/agBbam+b8UMo/5IckPEbLjcj2ek57gxpc6XEQW9LQqEve0woUwyUAwB8t5
         sNH+gge4yCKgyoyBO1WY+VLbS9T9JJlOhjn6pYnh3ql/BLymOFMY/neyou2futyMmpZw
         ZiqKmxYA5lAc71RDtnfElrPKTqlPj9m+0Z868=
From: Matti Lammi <mattij.lammi@gmail.com>
To: gregkh@suse.de, andrea.gelmini@gelma.net, mattij.lammi@gmail.com,
       bzolnier@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rt3070: Fixed a line over 80 character warning reported by checkpatch.pl tool
Date: Thu, 10 Jun 2010 13:00:45 +0300
Message-Id: <1276164045-6003-1-git-send-email-mattij.lammi@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divided a comment line into two separet lines in drivers/staging/rt3070/md4.h.

Signed-off-by: Matti Lammi <mattij.lammi@gmail.com>
---
 drivers/staging/rt3070/md4.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt3070/md4.h b/drivers/staging/rt3070/md4.h
index b3fb637..7ae9ebb 100644
--- a/drivers/staging/rt3070/md4.h
+++ b/drivers/staging/rt3070/md4.h
@@ -31,7 +31,8 @@
 /* MD4 context. */
 typedef	struct	_MD4_CTX_	{
 	unsigned long	state[4];        /* state (ABCD) */
-	unsigned long	count[2];        /* number of bits, modulo 2^64 (lsb first) */
+	unsigned long	count[2];        /* number of bits, modulo 2^64
+					    (lsb first) */
 	u8	buffer[64];      /* input buffer */
 }	MD4_CTX;
 
-- 
1.6.0.4

