Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1IZXhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 19:37:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1IZXhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 19:37:18 -0400
Date: Mon, 26 Sep 2011 16:36:59 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/4] TTY: serial, fix locking imbalance
Message-ID: <20110926233659.GA22611@suse.de>
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
 <20110922224653.GB21296@kroah.com>
 <4E7CD560.8010706@suse.cz>
 <20110923190840.GA31009@suse.de>
 <4E7CDC30.8070607@gmail.com>
 <20110923220440.GC30017@suse.de>
 <4E7E187B.4060507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7E187B.4060507@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 07:50:51PM +0200, Jiri Slaby wrote:
> On 09/24/2011 12:04 AM, Greg KH wrote:
> > On Fri, Sep 23, 2011 at 09:21:20PM +0200, Jiri Slaby wrote:
> >> But if there are more trees depending on the tree, then OK, I will live
> >> with that ;).
> > 
> > For the tty tree, I really doubt it, but I am not sure (rumor has it
> > that some people are basing on it, but that might just be rumor.)
> 
> Ok, for the other uart patches I have, it would be convenient for me to
> have the possibility of rebase. Would you mind if I add something like
> uart-cleanup tree to the -next tree and will have the patches there
> until I send them to you?

linux-next is for stuff that people are confident will show up in the
next release, not for general "let's throw it out there to see if it
works" type thing.

> Just for the purpose of fine tuning (and rebasing) if something needs to
> be fixed in them. The code is so complex, that I'm afraid I omitted some
> semi-hidden dependency. And it would be great to fix patches like when I
> used to work with the -mm tree.

Perhaps you should just work with Andrew and put these in -mm for now
until you feel comfortable that it's all worked out and no rebasing
would be needed anymore?

thanks,

greg k-h
