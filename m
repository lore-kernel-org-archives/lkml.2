Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1HNQFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:05:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab1HNQFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:05:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:52 2011
Message-Id: <20110812210552.404199466@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [03/90] cris: fix the prototype of sync_serial_ioctl()
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: WANG Cong <xiyou.wangcong@gmail.com>

commit b4bc281266e84e9a432b588ebdcef5fb94dc8ecb upstream.

Fix:

  arch/cris/arch-v10/drivers/sync_serial.c:961: error: conflicting types for 'sync_serial_ioctl'

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/cris/arch-v10/drivers/sync_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -158,7 +158,7 @@ static int sync_serial_open(struct inode
 static int sync_serial_release(struct inode *inode, struct file *file);
 static unsigned int sync_serial_poll(struct file *filp, poll_table *wait);
 
-static int sync_serial_ioctl(struct file *file,
+static long sync_serial_ioctl(struct file *file,
 	unsigned int cmd, unsigned long arg);
 static ssize_t sync_serial_write(struct file *file, const char *buf,
 	size_t count, loff_t *ppos);


