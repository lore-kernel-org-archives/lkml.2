Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1GHOuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:50:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1GHOt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:49:59 -0400
Date: Fri, 8 Jul 2011 07:43:42 -0700
From: Greg KH <gregkh@suse.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Airlie <airlied@linux.ie>
Subject: Re: [089/107] drivers/base/platform.c: dont mark
 platform_device_register_resndata() as __init_or_module
Message-ID: <20110708144342.GA22691@suse.de>
References: <20110708001740.GA14031@kroah.com>
 <20110708001701.406081654@clark.kroah.org>
 <20110708064742.GM29624@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110708064742.GM29624@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 08:47:42AM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> On Thu, Jul 07, 2011 at 05:17:01PM -0700, Greg KH wrote:
> > 2.6.39-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > commit bb2b43fefab723f4a0760146e7bed59d41a50e53 upstream.
> > 
> > This reverts 737a3bb9416ce2a7c7a4 ("Driver core: move platform device
> > creation helpers to .init.text (if MODULE=n)").  That patch assumed that
> > platform_device_register_resndata() is only ever called from __init code
> > but that isn't true in the case ioctl->drm_ioctl->radeon_cp_init().
> > 
> > Addresses https://bugzilla.kernel.org/show_bug.cgi?id=35192
> > 
> > Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Now added.

> > Reported-by: Anthony Basile <blueness@gentoo.org>
> > Cc: Greg KH <gregkh@suse.de>
> > Cc: David Airlie <airlied@linux.ie>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> You might want to remove one of your sobs.

Heh, thanks for catching this, now done.

greg k-h
