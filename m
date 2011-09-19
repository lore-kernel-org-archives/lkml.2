Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1ISNJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:09:21 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45624 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755812Ab1ISNJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:09:19 -0400
X-Sasl-enc: hyo0D0zxCxZ6SMwnmXUR5WXILEr5NBoIUSXCX/HcBtp0 1316437758
Date: Mon, 19 Sep 2011 06:07:55 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
        Luciano Coelho <coelho@ti.com>, matti.j.aaltonen@nokia.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
Message-ID: <20110919130755.GA9829@kroah.com>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net>
 <20110918152835.GA30696@kroah.com>
 <4E763C3C.3050909@xenotime.net>
 <2282172.TF7nejTDIZ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2282172.TF7nejTDIZ@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 10:47:50AM +0200, Arnd Bergmann wrote:
> On Sunday 18 September 2011 11:45:16 Randy Dunlap wrote:
> > >> We have fallbacks to Andrew and/or GregKH currently, but GregKH is not
> > >> consistent or timely with applying drivers/misc/ patches.  It deserves better.
> > >> [added him to Cc: list]
> > > 
> > > I do try to handle patches sent to me for misc/ in time for the
> > > different merge windows as that directory contains drivers that have
> > > moved out of the staging/ directory.
> > > 
> > > But yes, I'm not the overall drivers/misc/ maintainer, do we really need
> > > one?  If so, I can easily start maintaining a development tree for it to
> > > keep it separate for the different driver authors to send me stuff and
> > > start tracking it more "for real" if Arnd doesn't want to do it.
> > 
> > We need for the patches to be applied in a timely manner.
> > Sometimes when there is no real maintainer, that does not happen.
> 
> I think the other equally import aspect of maintainership that
> drivers/misc (and drivers/char) needs is someone who says no to
> stuff that doesn't belong there and helps submitters to find a
> proper place where appropriate and to come up with a proper user
> interface abstraction.
> 
> I'm definitely willing to do that part.
> 
> Greg, how about we both formally take ownership of driver/{misc,char}
> and you track the patches while I do the bulk of the reviews? You
> are definitely better than me with the patch tracking workflow.

That sounds good to me, I'll be glad to collect the patches and push
them to Linus for both of those trees (might as well keep them in the
same git tree, no need to separate them, right?) and I'll rely on you
for review and acking them.  Much like I do today for the tty and serial
trees.

I'll go set up the trees locally today and when kernel.org opens back
up, make them public and add them to linux-next.

thanks,

greg k-h
