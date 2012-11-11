Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab2KKM0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:26:49 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2KKMZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:25:03 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 2/8] staging: line6: fix quoted string across lines in midibuf.c
Date: Sun, 11 Nov 2012 13:24:40 +0100
Message-Id: <1352636686-31170-3-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch warns when quoted strings are split across lines.  The
rationale is that quoted strings should be left on a single line so that
grep works.  (The 80 character line limit does not apply to quoted
strings.)

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/midibuf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/line6/midibuf.c b/drivers/staging/line6/midibuf.c
index 836e8c8..968e0de 100644
--- a/drivers/staging/line6/midibuf.c
+++ b/drivers/staging/line6/midibuf.c
@@ -64,9 +64,9 @@ int line6_midibuf_init(struct MidiBuffer *this, int size, int split)
 
 void line6_midibuf_status(struct MidiBuffer *this)
 {
-	pr_debug("midibuf size=%d split=%d pos_read=%d pos_write=%d "
-	       "full=%d command_prev=%02x\n", this->size, this->split,
-	       this->pos_read, this->pos_write, this->full, this->command_prev);
+	pr_debug("midibuf size=%d split=%d pos_read=%d pos_write=%d full=%d command_prev=%02x\n",
+		 this->size, this->split, this->pos_read, this->pos_write,
+		 this->full, this->command_prev);
 }
 
 int line6_midibuf_bytes_free(struct MidiBuffer *this)
-- 
1.7.12.1

