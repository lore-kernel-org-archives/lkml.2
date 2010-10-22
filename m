Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0JVSfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:35:54 -0400
Received: from kroah.org ([198.145.64.141]:41922 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596Ab0JVSVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/49] tty: Fix warning left over from TIOCGICOUNT changes
Date: Fri, 22 Oct 2010 11:21:06 -0700
Message-Id: <1287771688-14805-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/ssu100.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index 8bd60e3..f5312dd333 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -444,8 +444,6 @@ static int ssu100_ioctl(struct tty_struct *tty, struct file *file,
 		    unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct ssu100_port_private *priv = usb_get_serial_port_data(port);
-	void __user *user_arg = (void __user *)arg;
 
 	dbg("%s cmd 0x%04x", __func__, cmd);
 
-- 
1.7.2

