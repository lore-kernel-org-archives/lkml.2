Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334Ab1JESty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:49:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53575 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573Ab1JEStx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:49:53 -0400
Date: Wed, 5 Oct 2011 20:49:50 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: rtc-mc13xxx: Staticize mc13xxx_rtc_idtable
Message-ID: <20111005184950.GQ6949@pengutronix.de>
References: <1317825827.5849.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1317825827.5849.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 10:43:47PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
I have that change in my tree, too, in a combo commit that still needs
splitting and mailing out.

Thanks and Acked-by: me.
Uwe

> ---
>  drivers/rtc/rtc-mc13xxx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
> index 9d0c3b4..546f685 100644
> --- a/drivers/rtc/rtc-mc13xxx.c
> +++ b/drivers/rtc/rtc-mc13xxx.c
> @@ -399,7 +399,7 @@ static int __exit mc13xxx_rtc_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -const struct platform_device_id mc13xxx_rtc_idtable[] = {
> +static const struct platform_device_id mc13xxx_rtc_idtable[] = {
>  	{
>  		.name = "mc13783-rtc",
>  	}, {

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
