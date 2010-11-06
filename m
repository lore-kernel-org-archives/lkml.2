Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab0KFSsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:48:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45810 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0KFSsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=n7fsT5vmKdl5swRqirutPpbU4LeTdMrp3/0FHbJMRbrv0lYHWrZmwAdSiITYag5Kf8
         Dqd3Bvle3QmSksV8keVeQ+uzliGCMz7GhKt/Xe450dZEw56jwkdOrCuqvxT1x1kxS2Us
         eHpC77SwF0sTrNkj4f4kz+VvuF6Z5m8ttjBeU=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Staging: speakup: spk_types: trival coding style issue
Date: Sat,  6 Nov 2010 14:48:48 -0400
Message-Id: <1289069328-1812-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch.pl gives WARNING: missing space after struct definition.
This patch fixes that warning that was on line 55.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/speakup/spk_types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/speakup/spk_types.h b/drivers/staging/speakup/spk_types.h
index 840bddb..d36c90e 100644
--- a/drivers/staging/speakup/spk_types.h
+++ b/drivers/staging/speakup/spk_types.h
@@ -52,7 +52,7 @@ typedef int (*special_func)(struct vc_data *vc, u_char type, u_char ch,
 
 #define COLOR_BUFFER_SIZE 160
 
-struct spk_highlight_color_track{
+struct spk_highlight_color_track {
 	/* Count of each background color */
 	unsigned int bgcount[8];
 	/* Buffer for characters drawn with each background color */
-- 
1.7.3

