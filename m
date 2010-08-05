Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343Ab0HEWhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:37:21 -0400
Received: from kroah.org ([198.145.64.141]:41640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934631Ab0HEWhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:37:05 -0400
Date: Thu, 5 Aug 2010 15:34:35 -0700
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-usb@vger.kernel.org,
        =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/2 v2] usb gadget: don't save bind callback in struct
 usb_configuration
Message-ID: <20100805223435.GC18619@kroah.com>
References: <op.vgyjjx1d7p4s8u@pikus>
 <1281001817-7807-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1281001817-7807-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 11:50:17AM +0200, Uwe Kleine-König wrote:
> The bind function is most of the time only called at init time so there is no
> need to save a pointer to it in the configuration structure.
> 
> This fixes many section mismatches reported by modpost.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Michał Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
> changes since v1:

I'm confused, can you resend what you want me to apply please?

Do I need to drop Michał's patch before applying yours?

thanks,

greg k-h
