Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab2JIQt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:49:26 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53396 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2JIQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:49:22 -0400
Date: Tue, 9 Oct 2012 09:46:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>, pavel@ucw.cz,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: winbond: wbusb: Fixed coding style issue
Message-ID: <20121009164614.GA17274@kroah.com>
References: <1349799055-4496-1-git-send-email-mujeeb.adil@gmail.com>
 <1349799738.2386.1.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349799738.2386.1.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 09:22:18AM -0700, Joe Perches wrote:
> On Tue, 2012-10-09 at 21:40 +0530, Adil Mujeeb wrote:
> > Repalces printk's with pr_debug
> []
> > diff --git a/linux-3.6-rc7/drivers/staging/winbond/wbusb.c b/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
> > index 0ca857a..48fe622 100644
> > --- a/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
> > +++ b/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
> > @@ -79,18 +79,18 @@ static int wbsoft_add_interface(struct ieee80211_hw *dev,
> >  static void wbsoft_remove_interface(struct ieee80211_hw *dev,
> >  				    struct ieee80211_vif *vif)
> >  {
> > -	printk("wbsoft_remove interface called\n");
> > +	pr_debug("wbsoft_remove interface called\n");
> 
> It'd be more consistent to use
> 	pr_debug("%s called\n", __func__);
> everywhere.
> 
> It might be even nicer to remove almost all of these.
> 

Yes, "tracing" type debug calls like this should all be removed, now
that we have built-in function call tracing in the core kernel itself.

greg k-h
