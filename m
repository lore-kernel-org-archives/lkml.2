Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2B0I7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:59:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40505 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2B0I7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 03:59:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.213.21.145 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F4B45F6.4090706@suse.cz>
Date: Mon, 27 Feb 2012 09:59:34 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
CC: Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>,
        gigaset307x-common@lists.sourceforge.net,
        Jiri Slaby <jirislaby@gmail.com>
Subject: "whitespace coding style cleanup" broke coding style
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 475be4d85a274d0961593db41cf85689db1d583c
Author: Joe Perches <joe@perches.com>
Date:   Sun Feb 19 19:52:38 2012 -0800

     isdn: whitespace coding style cleanup

     isdn source code uses a not-current coding style.
...
     Done with emacs and some scripts and some typing.
...
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
...
@@ -680,9 +680,9 @@ void gigaset_if_initdriver(struct gigaset_driver 
*drv, const
  char *procname,
                 goto enomem;

         tty->magic =            TTY_DRIVER_MAGIC,
-       tty->type =             TTY_DRIVER_TYPE_SERIAL,
-       tty->subtype =          SERIAL_TYPE_NORMAL,
-       tty->flags =            TTY_DRIVER_REAL_RAW | 
TTY_DRIVER_DYNAMIC_DEV;
+               tty->type =             TTY_DRIVER_TYPE_SERIAL,
+               tty->subtype =          SERIAL_TYPE_NORMAL,
+               tty->flags =            TTY_DRIVER_REAL_RAW | 
TTY_DRIVER_DYNAMIC_DEV;

Hmm, please, fix your scripts or emacs!

Through which tree did this get in?

thanks,
-- 
js
suse labs
