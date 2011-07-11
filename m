Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab1GKNZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:25:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757495Ab1GKNZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:25:17 -0400
Date: Mon, 11 Jul 2011 09:25:11 -0400
From: David Teigland <teigland@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, linux-kernel@vger.kernel.org
Subject: Re: kmallocs with swapped parameters in fs/dlm/lock.c
Message-ID: <20110711132511.GB14426@redhat.com>
References: <20110710003032.GA19951@gallifrey>
 <alpine.LNX.2.00.1107102254370.2818@swampdragon.chaosbits.net>
 <20110711082536.GA29007@gallifrey>
 <alpine.LNX.2.00.1107111032490.4462@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107111032490.4462@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 10:33:20AM +0200, Jesper Juhl wrote:
> On Mon, 11 Jul 2011, Dr. David Alan Gilbert wrote:
> 
> > * Jesper Juhl (jj@chaosbits.net) wrote:
> > > On Sun, 10 Jul 2011, Dr. David Alan Gilbert wrote:
> > > 
> > > > Hi David,
> > > >   Sparse spotted a couple of places in fs/dlm/lock.c where the size/flags
> > > > parameters to kmalloc got swapped:
> > > > 
> > > [...]
> > > > Jesper:
> > > >   I noticed in your patch:
> > > > https://lkml.org/lkml/2011/7/2/90
> > > > 
> > > > where you had done a kmalloc->kzalloc transform you kept the swap.
> > > > 
> > > > This looks like new code in 3.0rc so I don't think you could quite
> > > > call it a regression, but it should probably be fixed fairly quickly
> > > > I guess.
> > > > 
> > > D'oh, I completely overlooked that.
> > 
> > No problem.
> > 
> > > Thank you for noticing and letting me know. I've just submitted an updated 
> > > patch.
> > 
> > Great - it's probably worth you fixing the 2nd case in the same file
> > in the same patch, rather than just the one that you were changing
> > anyway?
> > 
> I guess so. I'll update my patch later this evening when I get home from 
> work.

I'll wait for your patch(es) before fixing any of these myself.
Thanks,
Dave
