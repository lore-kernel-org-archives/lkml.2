Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab3AHSjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:39:43 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51019 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab3AHSjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:39:41 -0500
From: Lijo Antony <lijo.kernel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@braille.uwo.ca,
        samuel.thibault@ens-lyon.org, linux-kernel@vger.kernel.org,
        Lijo Antony <lijo.kernel@gmail.com>
Subject: [PATCH 1/3] Staging: speakup: buffers.c: checkpatch.pl fixes
Date: Tue,  8 Jan 2013 22:39:01 +0400
Message-Id: <1357670343-15021-1-git-send-email-lijo.kernel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed two camel case issues.

Signed-off-by: Lijo Antony <lijo.kernel@gmail.com>
---
 drivers/staging/speakup/buffers.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/speakup/buffers.c b/drivers/staging/speakup/buffers.c
index a2db956..382973e 100644
--- a/drivers/staging/speakup/buffers.c
+++ b/drivers/staging/speakup/buffers.c
@@ -5,12 +5,12 @@
 #include "speakup.h"
 #include "spk_priv.h"
 
-#define synthBufferSize 8192	/* currently 8K bytes */
+#define SYNTH_BUF_SIZE 8192	/* currently 8K bytes */
 
-static u_char synth_buffer[synthBufferSize];	/* guess what this is for! */
+static u_char synth_buffer[SYNTH_BUF_SIZE];	/* guess what this is for! */
 static u_char *buff_in = synth_buffer;
 static u_char *buff_out = synth_buffer;
-static u_char *buffer_end = synth_buffer+synthBufferSize-1;
+static u_char *buffer_end = synth_buffer + SYNTH_BUF_SIZE - 1;
 
 /* These try to throttle applications by stopping the TTYs
  * Note: we need to make sure that we will restart them eventually, which is
@@ -44,13 +44,13 @@ static void speakup_stop_ttys(void)
 
 static int synth_buffer_free(void)
 {
-	int bytesFree;
+	int bytes_free;
 
 	if (buff_in >= buff_out)
-		bytesFree = synthBufferSize - (buff_in - buff_out);
+		bytes_free = SYNTH_BUF_SIZE - (buff_in - buff_out);
 	else
-		bytesFree = buff_out - buff_in;
-	return bytesFree;
+		bytes_free = buff_out - buff_in;
+	return bytes_free;
 }
 
 int synth_buffer_empty(void)
-- 
1.7.10.4

