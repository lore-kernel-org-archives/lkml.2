Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0DTWOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 18:14:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab0DTWOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 18:14:31 -0400
Date: Tue, 20 Apr 2010 15:13:18 -0700
From: Greg KH <gregkh@suse.de>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andi@firstfloor.org, alan@lxorguk.ukuu.org.uk, tytso@mit.edu,
       iws@ovro.caltech.edu
Subject: Re: [PATCH 0/4] enhanced reimplemention of the kfifo API
Message-ID: <20100420221318.GA2411@suse.de>
References: <1271794000-18897-1-git-send-email-stefani@seibold.net>
 <20100420201642.GA32373@suse.de>
 <1271795747.16051.18.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271795747.16051.18.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 10:35:47PM +0200, Stefani Seibold wrote:
> >  
> > > This are the features which are currently not used in the kernel:
> > > 
> > > kfifo_to_user()
> > > kfifo_from_user()
> > > kfifo_dma_....() macros
> > > kfifo_esize()
> > > kfifo_recsize()
> > > kfifo_put()
> > > kfifo_get()
> > > the fixed size record elements, exclude "unsigned char" fifo's and
> > > the variable size records fifo's
> > 
> > If you have features that have no users, why add them?  Do you think
> > that some drivers need/want these features?
> > 
> 
> Some developers ask me for this features, so i am a nice girl and
> implemented it. Especially the kfifo_to_user() and kfifo_from_user() was
> desired and is IMHO very useful. 
> 
> kfifo_put(), kfifo_get(), kfifo_esize() and kfifo_recsize() didn't coast
> anything, because there are only macros.
> 
> Andrew agreed that we add this for a given time period, and have a look
> what happens. The code overhead is not to much.
> 
> It is a chicken and egg problem: If we do not provide this features,
> nobody can use it and everyone will write it's own implementation.

Ok, fair enough.

thanks,

greg k-h
