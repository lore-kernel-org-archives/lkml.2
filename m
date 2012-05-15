Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965584Ab2EOCZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:25:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:49874 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965550Ab2EOCSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 175/179] nozomi: Fix warning from the previous TIOCGCOUNT changes
Date: Mon, 14 May 2012 22:14:31 -0400
Message-ID: <1337048075-6132-176-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 68e29655cc51761d60d5f27b2738816a5b13e415 upstream.

Just remove a now unused variable

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/nozomi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 0924435..7ecca24 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1829,7 +1829,6 @@ static int ntty_ioctl(struct tty_struct *tty, struct file *file,
 		      unsigned int cmd, unsigned long arg)
 {
 	struct port *port = tty->driver_data;
-	void __user *argp = (void __user *)arg;
 	int rval = -ENOIOCTLCMD;
 
 	DBG1("******** IOCTL, cmd: %d", cmd);
-- 
1.7.9.6

