Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965914Ab2B1WFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:05:54 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53054 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964833Ab2B1WFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:05:53 -0500
Message-ID: <1330466751.21481.18.camel@joe2Laptop>
Subject: Re: "whitespace coding style cleanup" broke coding style
From: Joe Perches <joe@perches.com>
To: Tilman Schmidt <tilman@imap.cc>, Karsten Keil <isdn@linux-pingi.de>
Cc: Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net,
        Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>
Date: Tue, 28 Feb 2012 14:05:51 -0800
In-Reply-To: <4F4D15E1.3090306@imap.cc>
References: <4F4B45F6.4090706@suse.cz> <1330361549.9942.7.camel@joe2Laptop>
	 <4F4D15E1.3090306@imap.cc>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 18:58 +0100, Tilman Schmidt wrote:
> Please remember to CC the maintainers of the affected code this time.

Karsten Keil is the nominal maintainer for
all of drivers/isdn.

I sent the patch/pull request directly to him
and cc'd netdev.  I did not send the patch/pull
request to isdn4linux as it's a subscriber-only
list and I'm not subscribed nor do I wish to be.

ISDN SUBSYSTEM
M:	Karsten Keil <isdn@linux-pingi.de>
L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
L:	netdev@vger.kernel.org
W:	http://www.isdn4linux.de
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/isdn-2.6.git
S:	Maintained
F:	Documentation/isdn/
F:	drivers/isdn/

If isdn4linux is an active list, (the archive doesn't
appear so http://listserv.isdn4linux.de/pipermail/isdn4linux/)
I suggest moving it to vger or making it moderated or open.

The git tree is no longer on git.kernel.org.
Perhaps that should be restored as well.

Karsten, you don't seem to have much activity
recently in drivers/isdn git history.

Are you still a MAINTAINER for isdn?

If Karsten is not really active, is there a
volunteer to take his place?

