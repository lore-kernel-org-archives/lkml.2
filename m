Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745Ab0HEXFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:05:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0HEXFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:05:09 -0400
Date: Thu, 5 Aug 2010 16:04:35 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Vincent GUITTOT <vincent.guittot@stericsson.com>
Subject: Re: [PATCH] U6715 16550A serial driver support
Message-ID: <20100805230435.GA30372@suse.de>
References: <1280739519-26930-1-git-send-email-philippe.langlais@stericsson.com>
 <20100804125253.3977b0d7.akpm@linux-foundation.org>
 <4C5A64E0.5060807@stericsson.com>
 <20100805002206.758777aa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805002206.758777aa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 12:22:06AM -0700, Andrew Morton wrote:
> On Thu, 5 Aug 2010 09:14:40 +0200 Philippe Langlais <philippe.langlais@stericsson.com> wrote:
> 
> > 
> > >>      
> > > The patch adds these .set_termios hooks but doesn't actually use them
> > > for anything.
> > >
> > > The changelog doesn't tell us _why_ this was done (it should) and
> > > lacking any code to look at it's all a bit mysterious.
> > >
> > >    
> > This feature is used in our U6715 8250 platform serial driver, to avoid
> > hack in 8250.c set_termios (Alan Cox requirement).
> > In this driver the input uart clock frequency depends on baud rate and
> > is computed in our set_termios override function.
> > The U6715 paltform serial patch has been submitted on linux-arm mailing 
> > list,
> > and is ready to enter Russell King Linux tree.
> 
> Oh.
> 
> > More things to do ?
> 
> Update the changelog to include this rather important information.
> 
> As the patches are dependent, treat them as a single series.  Russell
> can merge them both with Greg's ack or Greg can merge them both with
> Russell's ack.

I've dropped the patch from my tree, so send it through Russell's, with
the proper changelog change and:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
