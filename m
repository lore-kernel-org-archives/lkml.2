Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab1FHAGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:06:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:46459 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab1FHAGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:06:35 -0400
Subject: Re: [PATCHES v3] pci/of: Generic PCI <-> OF matching
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, bheglaas@google.com, monstr@monstr.eu,
        tglx@linutronix.de, bigeasy@linutronix.de, linux-pci@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1307482663.2874.171.camel@pasglop>
References: <1302495170-973-1-git-send-email-benh@kernel.crashing.org>
	 <1307426323.2874.157.camel@pasglop>
	 <20110607090559.149f611b@jbarnes-desktop>
	 <1307482663.2874.171.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 10:06:05 +1000
Message-ID: <1307491565.2874.173.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 07:37 +1000, Benjamin Herrenschmidt wrote:
> > > No significant changes (other than a rebase) nor new feedback since last
> > > time, I've also added a few acks I got. But not worth spamming the list
> > > with a re-post.
> > > 
> > > I'd like this to go into -next now so it can hit the next merge window,
> > > unless somebody objects.
> > > 
> > > I've put the series in a branch "of-pci" of my powerpc.git repo at:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git of-pci
> > > 
> > > Please let me know if you're ok (and maybe give me Ack's) and I'll ask
> > > Stephen to add it to next.
> > 
> > Yeah, the generic bits look good to me, you can add my
> >   Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> Great. Will do. I'll ask Stephen to that that in -next then and will ask
> Linus to pull directly at the next merge window, separately from
> powerpc.git (tho I might actually end up pulling that tree into
> powerpc.git too as I might end up with stuff that depends on it).

Allright, Stephen, can you stick this into -next please ?

git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git of-pci

I've added Jesse's acks.

Thanks !

Cheers,
Ben.


