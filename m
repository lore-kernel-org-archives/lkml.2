Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab0C1Tgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 15:36:50 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36896 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab0C1Tgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 15:36:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hhH3O4XPUAfNyrgKf0tZL7Nwa12mZSqqtwzlVh79RCsHmJSb07znvn42WiiWR1AsFs
         Wjrr6/9eskjbJO1tym7h8i7xjJl4I+DXUFYJG7cg35k77DwM8LZMVcyqqjIZ01CrNpYn
         igjOd4/syA/HU9n9bCYsjx/6tgtsBWyJPaQUA=
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 2/2] Staging: line6: fixed 80 character coding style issue in midibuf.c This is a patch to the midibuf.c file that fixes up an 80 character error thrown by the checkpatch.pl tool Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
Date: Sun, 28 Mar 2010 21:36:38 +0200
Message-Id: <1269804998-7169-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/line6/midibuf.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/line6/midibuf.c b/drivers/staging/line6/midibuf.c
index ab0a5f3..fb2658d 100644
--- a/drivers/staging/line6/midibuf.c
+++ b/drivers/staging/line6/midibuf.c
@@ -76,7 +76,8 @@ int midibuf_bytes_free(struct MidiBuffer *this)
 	return
 		midibuf_is_full(this) ?
 		0 :
-		(this->pos_read - this->pos_write + this->size - 1) % this->size + 1;
+		(this->pos_read - this->pos_write + this->size - 1) % \
+			this->size + 1;
 }
 
 int midibuf_bytes_used(struct MidiBuffer *this)
@@ -84,7 +85,8 @@ int midibuf_bytes_used(struct MidiBuffer *this)
 	return
 		midibuf_is_empty(this) ?
 		0 :
-		(this->pos_write - this->pos_read + this->size - 1) % this->size + 1;
+		(this->pos_write - this->pos_read + this->size - 1) % \
+			this->size + 1;
 }
 
 int midibuf_write(struct MidiBuffer *this, unsigned char *data, int length)
@@ -160,7 +162,8 @@ int midibuf_read(struct MidiBuffer *this, unsigned char *data, int length)
 		this->command_prev = command;
 	} else {
 		if (this->command_prev > 0) {
-			int midi_length_prev = midibuf_message_length(this->command_prev);
+			int midi_length_prev = \
+				midibuf_message_length(this->command_prev);
 
 			if (midi_length_prev > 0) {
 				midi_length = midi_length_prev - 1;
-- 
1.6.3.3

