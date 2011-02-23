Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1BWJ6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:58:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47466 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab1BWJ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:58:00 -0500
Date: Wed, 23 Feb 2011 10:57:56 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Subject: Re: [PATCH 1/2] rtc: rtc-mc13xxx: fix unterminated
 platform_device_id table
Message-ID: <20110223095756.GQ22310@pengutronix.de>
References: <1298453244.25444.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1298453244.25444.1.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 05:27:24PM +0800, Axel Lin wrote:
> The platform_device_id table is supposed to be zero-terminated.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/rtc/rtc-mc13xxx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
> index 5314b15..6e6de98 100644
> --- a/drivers/rtc/rtc-mc13xxx.c
> +++ b/drivers/rtc/rtc-mc13xxx.c
> @@ -408,6 +408,7 @@ const struct platform_device_id mc13xxx_rtc_idtable[] = {
>  	}, {
>  		.name = "mc13892-rtc",
>  	},
> +	{ }
>  };
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
for both patches.  I wonder how that worked before, just luck I assume.

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
