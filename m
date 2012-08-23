Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030447Ab2HWLCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 07:02:12 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48317 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030351Ab2HWLCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 07:02:08 -0400
Date: Thu, 23 Aug 2012 13:02:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Chris Zankel <chris@zankel.net>, "3.2.x.." <stable@kernel.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Parisc <linux-parisc@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        m68k <linux-m68k@vger.kernel.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>
Subject: Re: [PATCH 00/10] rcu: Add missing RCU idle APIs on idle loop
Message-ID: <20120823110157.GC18835@somewhere.redhat.com>
References: <1345652628-15060-1-git-send-email-fweisbec@gmail.com>
 <CAMuHMdUt62GsYsPMAPbUWZUtFL=c2VmYFintpDAQmSwQrWriuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUt62GsYsPMAPbUWZUtFL=c2VmYFintpDAQmSwQrWriuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 07:18:04PM +0200, Geert Uytterhoeven wrote:
> On Wed, Aug 22, 2012 at 6:23 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > So this fixes some potential RCU stalls in a bunch of architectures.
> > When rcu_idle_enter()/rcu_idle_exit() became a requirement, we forgot
> > to handle the architectures that don't support CONFIG_NO_HZ.
> >
> > I guess the set should be dispatched into arch maintainer trees.
> 
> I can take the m68k version, but are you sure you want it this way?
> Each of them must be in mainline before they can enter stable.

Yeah, I was thinking the right route is for these patches to be
carried by arch maintainer who then push to Linus and then this goes
to stable.

Is that ok for you?

Otherwise I can carry the patches myself. In a tree of my own, or
Paul's or mmotm. As long as I have your ack.

Thanks.

> 
> > I'm sorry I haven't built tested everywhere. But the changes are
> > small and need to be at least boot tested anyway.
> 
> Builds and boots fine on m68k under ARAnyM.
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> (for m68k)
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
