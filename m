Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0HBR21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:28:27 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:49397 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0HBR20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:28:26 -0400
Date: Mon, 2 Aug 2010 19:28:20 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <gregkh@suse.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [098/140] USB: ehci-mxc: bail out on transceiver problems
Message-ID: <20100802172819.GJ17833@buzzloop.caiaq.de>
References: <20100730173205.GA22581@kroah.com>
 <20100730173111.572059486@clark.site>
 <20100802124514.GD6193@pengutronix.de>
 <20100802171050.GB7915@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802171050.GB7915@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 10:10:50AM -0700, Greg KH wrote:
> On Mon, Aug 02, 2010 at 02:45:14PM +0200, Wolfram Sang wrote:
> > Daniel mentioned that this patch could cause a "regression" with boards
> > which have hardware problems in form of a floating chip select
> > (originating from the reference design!). For such boards, the probing
> > might now fail, leaving the boards without USB, while it worked before
> > (although it only worked because of ignoring the actual problem).
> > 
> > I can't make my mind if it is better to fix the potential OOPS or to
> > keep those boards working for older kernels. I just wanted to mention
> > it, so this is issue won't be overlooked.
> 
> Odd.  Well, I'd rather match what the newer kernels do here, so I'll
> keep it for now unless someone objects.

Yep, I was about to write the same thing. Let's see what it breaks and
fix up the mess afterwards :)

Thanks,
Daniel

