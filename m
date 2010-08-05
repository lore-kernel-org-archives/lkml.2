Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab0HEJp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:45:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59879 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0HEJpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:45:53 -0400
Date: Thu, 5 Aug 2010 11:45:46 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/2] usb gadget: don't save bind callback in struct
	usb_configuration
Message-ID: <20100805094545.GB22207@pengutronix.de>
References: <20100802182521.GA4151@pengutronix.de> <1280773666-5405-2-git-send-email-u.kleine-koenig@pengutronix.de> <op.vgyjjx1d7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vgyjjx1d7p4s8u@pikus>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 11:05:47AM +0200, Michał Nazarewicz wrote:
> On Mon, 02 Aug 2010 20:27:46 +0200, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
>
>> The bind function is only called at init time so there is no need to
>> save a pointer to it in the driver struct.
>
> This is not entirely true.  How about such wording:
>
>   The bind function is often called only at init time so there is no neet
>   to save a pointer to it in the configuration structure.
OK.

> Also note, that if you are fixing composite gadgets as well, there's also
> usb_composite_driver structure and accompanying usb_composite_register()
> function.
This is ortogonal to my two patches, right?  Will look into it later.

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
