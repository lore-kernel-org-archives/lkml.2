Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1BOJ0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:26:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab1BOJZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:25:58 -0500
Date: Tue, 15 Feb 2011 10:25:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] mISDN: fix printk typo fushing
In-Reply-To: <alpine.LNX.2.00.1102150012140.4530@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1102151025500.2160@pobox.suse.cz>
References: <1297724762.1793.35.camel@t41.thuisdomein> <alpine.LNX.2.00.1102150012140.4530@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Jesper Juhl wrote:

> On Tue, 15 Feb 2011, Paul Bolle wrote:
> 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> >  drivers/isdn/mISDN/hwchannel.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/isdn/mISDN/hwchannel.c b/drivers/isdn/mISDN/hwchannel.c
> > index 199f374..f6e108d 100644
> > --- a/drivers/isdn/mISDN/hwchannel.c
> > +++ b/drivers/isdn/mISDN/hwchannel.c
> > @@ -206,7 +206,7 @@ recv_Bchannel(struct bchannel *bch, unsigned int id)
> >  	hh->id = id;
> >  	if (bch->rcount >= 64) {
> >  		printk(KERN_WARNING "B-channel %p receive queue overflow, "
> > -			"fushing!\n", bch);
> > +			"flushing!\n", bch);
> >  		skb_queue_purge(&bch->rqueue);
> >  		bch->rcount = 0;
> >  		return;
> > @@ -231,7 +231,7 @@ recv_Bchannel_skb(struct bchannel *bch, struct sk_buff *skb)
> >  {
> >  	if (bch->rcount >= 64) {
> >  		printk(KERN_WARNING "B-channel %p receive queue overflow, "
> > -			"fushing!\n", bch);
> > +			"flushing!\n", bch);
> >  		skb_queue_purge(&bch->rqueue);
> >  		bch->rcount = 0;
> >  	}
> > @@ -279,7 +279,7 @@ confirm_Bsend(struct bchannel *bch)
> >  
> >  	if (bch->rcount >= 64) {
> >  		printk(KERN_WARNING "B-channel %p receive queue overflow, "
> > -			"fushing!\n", bch);
> > +			"flushing!\n", bch);
> >  		skb_queue_purge(&bch->rqueue);
> >  		bch->rcount = 0;
> >  	}
> > 

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
