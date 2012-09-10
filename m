Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2IJV4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 17:56:16 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:45951 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2IJV4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 17:56:15 -0400
X-Greylist: delayed 1526 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Sep 2012 17:56:14 EDT
Date: Mon, 10 Sep 2012 23:56:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, "3.2.x.." <stable@vger.kernel.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Parisc <linux-parisc@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        m68k <linux-m68k@vger.kernel.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>,
        Michael Cree <mcree@orcon.net.nz>
Subject: Re: [PATCH 00/11] rcu: Add missing RCU idle APIs on idle loop v2
Message-ID: <20120910215541.GE21277@somewhere.redhat.com>
References: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
 <20120824212647.GU2472@linux.vnet.ibm.com>
 <1345857554.4840.43.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345857554.4840.43.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 02:19:14AM +0100, Ben Hutchings wrote:
> On Fri, 2012-08-24 at 14:26 -0700, Paul E. McKenney wrote:
> > On Thu, Aug 23, 2012 at 04:58:24PM +0200, Frederic Weisbecker wrote:
> > > Hi,
> > > 
> > > Changes since v1:
> > > 
> > > - Fixed preempt handling in alpha idle loop
> > > - added ack from Geert
> > > - fixed stable email address, sorry :-/
> > > 
> > > This time I built tested everywhere but: h8300 (compiler internal error),
> > > and mn10300, parisc, score (cross compilers not available in
> > > ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/)
> > > 
> > > For testing, you can pull from:
> > > 
> > > git://github.com/fweisbec/linux-dynticks.git
> > > 	rcu/idle-fix-v2 
> > > 
> > > Thanks.
> > 
> > I have queued these on -rcu branch rcu/idle:
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> > 
> > This problem has been in place since 3.3, so it is hard to argue that
> > it is a regression for this merge window.  I have therefore queued it
> > for 3.7.
> 
> I don't follow that; I would expect any serious bug fix (serious enough
> for a stable update) to be acceptable for 3.6 at this point.
> 
> If the regression occurred in 3.3, then the cc lines should be something
> like:
> 
>     Cc: <stable@vger.kernel.org> # 3.3+
> 
> and not the current:
> 
>     Cc: 3.2.x.. <stable@vger.kernel.org>
> 
> (Note, version annotations should be on the right of the address, not in
> the 'real name' position on the left.)

Ah indeed.

Hmm, I don't understand why we took that convention while we can reuse the name
that precedes the email to put that information.

Anyway, should I resend the patchset with this thing fixed?

Thanks.
