Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab0JHKPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:15:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47075 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227Ab0JHKOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Mu4t7+4yKETlMYnGxgHrdZdEjKAC//ORJ1a5MyfAfT9qQ/Ebtoyy/FQ4BCpXzkJ68Q
         n22LwnePJ5VP4sTXRiSN73+2Diu6JQ9mop1YBjNvK5WxgOtPMbAN9OnRqbURZmk9uRwM
         DeSmZA/YtrG3oeb6BwOmg2UIsgJbJpD6EFWuM=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 3/3] Staging: speakup: keyhelp: Coding style fix
Date: Fri,  8 Oct 2010 06:14:45 -0400
Message-Id: <1286532885-5411-3-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
In-Reply-To: <1286532885-5411-1-git-send-email-tdent48227@gmail.com>
References: <1286532885-5411-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put { on previous line, on line 34. Checkpatch.pl caught this.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
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

