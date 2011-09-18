Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab1IRP2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 11:28:40 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39850 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709Ab1IRP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 11:28:38 -0400
X-Sasl-enc: 44ltXL/6gAKdOY5nxisZdbpjyfFq6uf3AgcRkr4Uk8QB 1316359717
Date: Sun, 18 Sep 2011 08:28:35 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Jean Delvare <khali@linux-fr.org>,
        Luciano Coelho <coelho@ti.com>, matti.j.aaltonen@nokia.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
Message-ID: <20110918152835.GA30696@kroah.com>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net>
 <201109021643.14275.arnd@arndb.de>
 <20110905144134.2c80c4b9@endymion.delvare>
 <201109051619.35553.arnd@arndb.de>
 <4E760A31.8030807@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E760A31.8030807@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 08:11:45AM -0700, Randy Dunlap wrote:
> On 09/05/2011 07:19 AM, Arnd Bergmann wrote:
> > I think it would simply be more consistent to have it enabled all
> > the time. Well, even better would be to move the bulk of the misc
> > drivers to a proper location sorted by their subsystems. A lot of them
> > should never have been merged in their current state IMHO.
> 
> 
> If it's clear where they belong, then sure, they should be somewhere
> other than drivers/misc/, but I don't see that it's clear for several
> of them.
> 
> 
> > I think I should finally do what has been  talked about a few times and
> > formally become the maintainer of drivers/char and drivers/misc ;-)
> > 
> > The problem is that I'm not actually a good maintainer, but maybe it's
> > better to just have someone instead of falling back to Andrew or
> > some random subsystem maintainer to send any patches for drivers/misc.
> 
> We have fallbacks to Andrew and/or GregKH currently, but GregKH is not
> consistent or timely with applying drivers/misc/ patches.  It deserves better.
> [added him to Cc: list]

I do try to handle patches sent to me for misc/ in time for the
different merge windows as that directory contains drivers that have
moved out of the staging/ directory.

But yes, I'm not the overall drivers/misc/ maintainer, do we really need
one?  If so, I can easily start maintaining a development tree for it to
keep it separate for the different driver authors to send me stuff and
start tracking it more "for real" if Arnd doesn't want to do it.

thanks,

greg k-h
