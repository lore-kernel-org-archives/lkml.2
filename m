Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1LHQrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:47:46 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:51953 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853Ab1LHQrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:47:45 -0500
From: =?UTF-8?q?Thorsten=20Wi=C3=9Fmann?= <re06huxa@cip.cs.fau.de>,
        =?UTF-8?q?Maximilian=20Kr=C3=BCger?= <maxfragg@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-kernel@i4.informatik.uni-erlangen.de,
        =?UTF-8?q?Thorsten=20Wi=C3=9Fmann?= <re06huxa@cip.cs.fau.de>,
        =?UTF-8?q?Maximilian=20Kr=C3=BCger?= <maxfragg@gmail.com>
Subject: [PATCH] drivers/tty: Remove unneeded spaces
Date: Thu,  8 Dec 2011 17:47:33 +0100
Message-Id: <1323362853-24100-1-git-send-email-re06huxa@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thorsten Wißmann <re06huxa@cip.cs.fau.de>

coding style fixes in n_tty.c

Signed-off-by: Maximilian Krüger <maxfragg@gmail.com>
Signed-off-by: Thorsten Wißmann <re06huxa@cip.cs.fau.de>
---
 drivers/tty/n_tty.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 39d6ab6..d2256d0 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -61,7 +61,7 @@
  * controlling the space in the read buffer.
  */
 #define TTY_THRESHOLD_THROTTLE		128 /* now based on remaining room */
-#define TTY_THRESHOLD_UNTHROTTLE 	128
+#define TTY_THRESHOLD_UNTHROTTLE	128
 
 /*
  * Special byte codes used in the echo buffer to represent operations
@@ -405,7 +405,7 @@ static ssize_t process_output_block(struct tty_struct *tty,
 				    const unsigned char *buf, unsigned int nr)
 {
 	int	space;
-	int 	i;
+	int	i;
 	const unsigned char *cp;
 
 	mutex_lock(&tty->output_lock);
@@ -1607,7 +1607,7 @@ static inline int input_available_p(struct tty_struct *tty, int amt)
 }
 
 /**
- * 	copy_from_read_buf	-	copy read data directly
+ *	copy_from_read_buf	-	copy read data directly
  *	@tty: terminal device
  *	@b: user data
  *	@nr: size of data
@@ -1909,7 +1909,7 @@ do_it_again:
 		if (nr)
 			clear_bit(TTY_PUSH, &tty->flags);
 	} else if (test_and_clear_bit(TTY_PUSH, &tty->flags))
-		 goto do_it_again;
+		goto do_it_again;
 
 	n_tty_set_room(tty);
 	return retval;
-- 
1.7.5.4

