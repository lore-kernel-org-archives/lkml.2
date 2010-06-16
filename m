Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab0FPQUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:20:14 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:60155 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755914Ab0FPQUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:20:12 -0400
Date: Wed, 16 Jun 2010 12:20:02 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] trivial: fix typos concerning "precedence"
Message-ID: <20100616162002.GA3558@elliptictech.com>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	trivial@kernel.org, linux-kernel@vger.kernel.org
References: <20100611101624.GD10894@pengutronix.de>
 <1276251424-12806-8-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276251424-12806-8-git-send-email-u.kleine-koenig@pengutronix.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:17 Fri 11 Jun     , Uwe Kleine-König wrote:
> diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
> index 7b8a2da..27b4cb2 100644
> --- a/drivers/staging/comedi/drivers/usbdux.c
> +++ b/drivers/staging/comedi/drivers/usbdux.c
> @@ -2085,7 +2085,7 @@ static int usbdux_pwm_start(struct comedi_device *dev,
>  	if (ret < 0)
>  		return ret;
>  
> -	/* initialise the buffer */
> +	/* initalise the buffer */
>  	for (i = 0; i < this_usbduxsub->sizePwmBuf; i++)
>  		((char *)(this_usbduxsub->urbPwm->transfer_buffer))[i] = 0;

This hunk (and the remainder of this patch) is undoing your earlier
"initiali[zs]e" changes.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
