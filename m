Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab0KGPYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 10:24:19 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:34186 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab0KGPYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 10:24:17 -0500
From: Arun Bhanu <arun@bhanu.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>, Alan Cox <alan@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Arun Bhanu <arun@bhanu.net>
Subject: [PATCH] drivers/char/nozomi.c: fix unused variable compiler warning
Date: Sun,  7 Nov 2010 23:20:55 +0800
Message-Id: <1289143255-587-1-git-send-email-arun@bhanu.net>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unused variable argp to fix the following warning.

drivers/char/nozomi.c: In function ‘ntty_ioctl’:
drivers/char/nozomi.c:1831:8: warning: unused variable ‘argp’

Signed-off-by: Arun Bhanu <arun@bhanu.net>
---
 drivers/char/nozomi.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index dd3f9b1..294d03e 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1828,7 +1828,6 @@ static int ntty_ioctl(struct tty_struct *tty, struct file *file,
 		      unsigned int cmd, unsigned long arg)
 {
 	struct port *port = tty->driver_data;
-	void __user *argp = (void __user *)arg;
 	int rval = -ENOIOCTLCMD;
 
 	DBG1("******** IOCTL, cmd: %d", cmd);
-- 
1.7.3.2

