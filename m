Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab2B2Tce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:32:34 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:50475 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754837Ab2B2Tcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:32:32 -0500
Message-ID: <1330543951.21491.15.camel@joe2Laptop>
Subject: Re: "whitespace coding style cleanup" broke coding style
From: Joe Perches <joe@perches.com>
To: Armin Schindler <armin@melware.de>
Cc: Tilman Schmidt <tilman@imap.cc>, Armin Schindler <mac@melware.de>,
        Karsten Keil <isdn@linux-pingi.de>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net,
        Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>
Date: Wed, 29 Feb 2012 11:32:31 -0800
In-Reply-To: <4F4DE175.30002@melware.de>
References: <4F4B45F6.4090706@suse.cz> <1330361549.9942.7.camel@joe2Laptop>
	 <4F4D15E1.3090306@imap.cc> <1330466751.21481.18.camel@joe2Laptop>
	 <4F4D5E84.8090404@imap.cc> <1330471687.31737.19.camel@joe2Laptop>
	 <4F4DE175.30002@melware.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 09:27 +0100, Armin Schindler wrote:
> On 02/29/2012 12:28 AM, Joe Perches wrote:
> > One of those, Armin Schindler, (cc'd) hasn't
> > signed a single commit in git history.
> True, my last work here was a long time ago.
> I used to maintain the eicon driver, but this driver
> is not just old, it is simply outdated for years and
> I doubt someone will ever use it in newer kernels.
> It just creates work here.

You could remove yourself from MAINTAINERS if you want.

 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d3ae86..d40a974 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3682,10 +3682,9 @@ F:	include/linux/isdn.h
 F:	include/linux/isdn/
 
 ISDN SUBSYSTEM (Eicon active card driver)
-M:	Armin Schindler <mac@melware.de>
 L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 W:	http://www.melware.de
-S:	Maintained
+S:	Orphan
 F:	drivers/isdn/hardware/eicon/
 
 IT87 HARDWARE MONITORING DRIVER

> Some time ago I asked (I don't remember who) why
> don't we remove that old driver from the kernel.
> It wasn't done because there is no follow up for the
> kernel. The new drivers out there are maintained,
> but will never be part of the kernel (coding style, etc.).
> I guess the idea was not to remove a driver from the kernel
> when there is no alternative (in kernel).
> Maybe I should bring this up again and ask for a removal of the
> current eicon driver in kernel...

Your choice.

It could be moved to staging as a prelude to removing
it after a few releases.

I did do a rather large drive-by whitespace cleanup
of eicon.  It still compiles.  I've no idea if it
still works though.

cheers, Joe

