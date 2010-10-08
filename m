Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab0JHKNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:13:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33332 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab0JHKNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g28bKZaUlMlVqlwHGki7ahn/cyXrkO1yDY01dFdIpQKwXD7YDUX4b9VKVF2QCTBz3Q
         ea0vLAE9ObZeI6LMnHMtqrFaK0unfLt1/af+QNX3Uuinxa4Ykd40D7mBdSUYD2rx9JBI
         Xwn9MliHSyLdXpD99xBBnVXrrPG21xkCrgwRk=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 3/3] Staging: speakup: keyhelp: Coding style fix
Date: Fri,  8 Oct 2010 06:13:30 -0400
Message-Id: <1286532810-5370-3-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
In-Reply-To: <1286532810-5370-1-git-send-email-tdent48227@gmail.com>
References: <1286532810-5370-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put { on previous line, on line 34. Checkpatch.pl caught this.
---
 drivers/staging/speakup/keyhelp.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/speakup/keyhelp.c b/drivers/staging/speakup/keyhelp.c
index 81c627c..a74500a 100644
--- a/drivers/staging/speakup/keyhelp.c
+++ b/drivers/staging/speakup/keyhelp.c
@@ -30,11 +30,11 @@ static const int num_key_names = MSG_KEYNAMES_END - MSG_KEYNAMES_START + 1;
 static u_short key_offsets[MAXFUNCS], key_data[MAXKEYS];
 static u_short masks[] = { 32, 16, 8, 4, 2, 1 };
 
-static short letter_offsets[26] =
-{ -1, -1, -1, -1, -1, -1, -1, -1,
-  -1, -1, -1, -1, -1, -1, -1, -1,
-  -1, -1, -1, -1, -1, -1, -1, -1,
-  -1, -1 };
+static short letter_offsets[26] = { 
+	-1, -1, -1, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1, -1, -1,
+	-1, -1, -1, -1, -1, -1, -1, -1,
+	-1, -1 };
 
 static u_char funcvals[] = {
 	ATTRIB_BLEEP_DEC, ATTRIB_BLEEP_INC, BLEEPS_DEC, BLEEPS_INC,
-- 
1.7.3.1.104.gc752e

