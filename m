Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab1GKIdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 04:33:22 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22081 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab1GKIdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 04:33:21 -0400
Date: Mon, 11 Jul 2011 10:33:20 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
cc: teigland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: kmallocs with swapped parameters in fs/dlm/lock.c
In-Reply-To: <20110711082536.GA29007@gallifrey>
Message-ID: <alpine.LNX.2.00.1107111032490.4462@swampdragon.chaosbits.net>
References: <20110710003032.GA19951@gallifrey> <alpine.LNX.2.00.1107102254370.2818@swampdragon.chaosbits.net> <20110711082536.GA29007@gallifrey>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Dr. David Alan Gilbert wrote:

> * Jesper Juhl (jj@chaosbits.net) wrote:
> > On Sun, 10 Jul 2011, Dr. David Alan Gilbert wrote:
> > 
> > > Hi David,
> > >   Sparse spotted a couple of places in fs/dlm/lock.c where the size/flags
> > > parameters to kmalloc got swapped:
> > > 
> > [...]
> > > Jesper:
> > >   I noticed in your patch:
> > > https://lkml.org/lkml/2011/7/2/90
> > > 
> > > where you had done a kmalloc->kzalloc transform you kept the swap.
> > > 
> > > This looks like new code in 3.0rc so I don't think you could quite
> > > call it a regression, but it should probably be fixed fairly quickly
> > > I guess.
> > > 
> > D'oh, I completely overlooked that.
> 
> No problem.
> 
> > Thank you for noticing and letting me know. I've just submitted an updated 
> > patch.
> 
> Great - it's probably worth you fixing the 2nd case in the same file
> in the same patch, rather than just the one that you were changing
> anyway?
> 
I guess so. I'll update my patch later this evening when I get home from 
work.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

