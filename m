Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601Ab0HFEuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 00:50:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40379 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab0HFEuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 00:50:50 -0400
Date: Fri, 6 Aug 2010 06:50:46 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org,
        =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/2 v2] usb gadget: don't save bind callback in struct
	usb_configuration
Message-ID: <20100806045046.GA13345@pengutronix.de>
References: <op.vgyjjx1d7p4s8u@pikus> <1281001817-7807-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100805223435.GC18619@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100805223435.GC18619@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 03:34:35PM -0700, Greg KH wrote:
> On Thu, Aug 05, 2010 at 11:50:17AM +0200, Uwe Kleine-König wrote:
> > The bind function is most of the time only called at init time so there is no
> > need to save a pointer to it in the configuration structure.
> > 
> > This fixes many section mismatches reported by modpost.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Michał Nazarewicz <m.nazarewicz@samsung.com>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> > changes since v1:
> 
> I'm confused, can you resend what you want me to apply please?
Will do.
 
> Do I need to drop Michał's patch before applying yours?
I double checked that now, and there is one thing in Michał's patch that
is not fixed in mine.  It's the hunk for drivers/usb/gadget/zero.c, as I
didn't touch struct usb_composite_driver yet.  So expect three patches
in reply to this mail.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
