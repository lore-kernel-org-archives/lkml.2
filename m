Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab1H3MoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:44:16 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:15476 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1H3MoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:44:14 -0400
Date: Tue, 30 Aug 2011 14:44:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Remove obsolete cleanup for clientdata
Message-ID: <20110830144403.35de68dc@endymion.delvare>
In-Reply-To: <1314269314-16324-1-git-send-email-w.sang@pengutronix.de>
References: <1314269314-16324-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 12:48:25 +0200, Wolfram Sang wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit or error. This is obsolete meanwhile, the core will do it.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/leds/leds-lm3530.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
> index 3dd7090..d2d25e6 100644
> --- a/drivers/leds/leds-lm3530.c
> +++ b/drivers/leds/leds-lm3530.c
> @@ -421,7 +421,6 @@ err_class_register:
>  err_reg_init:
>  	regulator_put(drvdata->regulator);
>  err_regulator_get:
> -	i2c_set_clientdata(client, NULL);
>  	kfree(drvdata);
>  err_out:
>  	return err;

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
