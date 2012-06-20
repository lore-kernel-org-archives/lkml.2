Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2FTPHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:07:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63629 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2FTPHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:07:13 -0400
Date: Wed, 20 Jun 2012 08:07:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Lockwood <lockwood@android.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>
Subject: Re: Re: [PATCH 1/2] extcon: Set platform drvdata in
 gpio_extcon_probe() and fix irq leak
Message-ID: <20120620150708.GA13770@kroah.com>
References: <25919571.619021340166725967.JavaMail.weblogic@epml24>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25919571.619021340166725967.JavaMail.weblogic@epml24>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 04:32:06AM +0000, MyungJoo Ham wrote:
> > On Tue, Jun 19, 2012 at 10:19:07AM +0000, 함명주 wrote:
> > > > Add missing platform_set_drvdata() in gpio_extcon_probe(), otherwise calling
> > > > platform_get_drvdata in gpio_extcon_remove() returns NULL.
> > > > 
> > > > Also add missing free_irq call in gpio_extcon_remove().
> > > > 
> > > > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > > 
> > > Thanks!
> > > 
> > > 
> > > Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > > 
> > > I'll apply this patch to the extcon-for-next.
> > > I would appear in http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next soon after syncing servers.
> > 
> > Does this mean you are going to have a separate extcon git tree
> > somewhere, feeding into linux-next, and sending stuff directly to Linus?
> > 
> > I don't see an entry in the MAINTAINERS file saying this, which is why I
> > was picking up extcon patches, should I not be doing this?
> > 
> > confused,
> > 
> > greg k-h
> > 
> 
> You are right. We do not have MAINTAINERS entry for extcon.

You can easily fix that (hint, hint, hint...)

> I can wait until we have MAINTAINERS entry registered for extcon,
> which we have not request or submit, yet. Until then, I think you may
> pick up the extcon patches and I will simply follow your repositories
> (keep rebasing from yours)

My trees never need rebasing, why would you need to do that?  What is
going into your tree that isn't in mine?  Am I missing patches?

I would be very glad for you to take over this maintainership, if it's
something you want to do, otherwise I have no problem taking the
patches.  It's up to you.

thanks,

greg k-h
