Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab0GAWLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:11:33 -0400
Received: from kroah.org ([198.145.64.141]:46738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab0GAWL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:11:26 -0400
Date: Thu, 1 Jul 2010 15:10:59 -0700
From: Greg KH <greg@kroah.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: 4 -stable kernel review cycles starting
Message-ID: <20100701221059.GA11663@kroah.com>
References: <20100701175100.GA2078@kroah.com>
 <201007012355.05531.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201007012355.05531.florian@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 11:55:02PM +0200, Florian Fainelli wrote:
> Hi,
> 
> Le Thursday 1 July 2010 19:51:00, Greg KH a écrit :
> > First off, sorry for the long delay in the -stable kernel releases, they
> > got pushed to the back-burner for other things recently ("Hey look, is
> > that the sun finally here in the Pacific Northwest?")
> > 
> > Please note that there are still a large number of patches that have
> > been submitted to the -stable trees for inclusion, that I have not
> > included yet.  Do not worry, they are still in my queue, but due to the
> > large number of patches that I already have queued up, I figured it was
> > better to get what I have applied already out for a release and then
> > work on catching up after this.
> > 
> > If anyone has any questions about this, please let me know.
> 
> Looks like this cpmac patch was not included in this -stable series: 
> http://www.spinics.net/lists/netdev/msg133317.html
> 
> Can you queue it for future -stable releases or this one?

{sigh}

Did you see the second paragraph above as to why it isn't in this
release?

And yes, it will be in future ones.

thanks,

greg k-h
