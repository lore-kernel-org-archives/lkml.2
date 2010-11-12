Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab0KLVlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:41:19 -0500
Received: from kroah.org ([198.145.64.141]:41595 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933048Ab0KLVlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/19] nozomi: Fix warning from the previous TIOCGCOUNT changes
Date: Fri, 12 Nov 2010 13:40:51 -0800
Message-Id: <1289598066-10112-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Just remove a now unused variable

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.1

