Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab0EZL2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:28:39 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:60293 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353Ab0EZL2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:28:38 -0400
Subject: Re: [PATCH] led-class: set permissions on max_brightness file to
 0444
From: Richard Purdie <rpurdie@rpsys.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, John Lenz <lenz@cs.wisc.edu>
In-Reply-To: <1274057308.9060.3.camel@mola>
References: <1274057308.9060.3.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 12:28:05 +0100
Message-ID: <1274873285.16229.83.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 08:48 +0800, Axel Lin wrote:
> max_brightness is not writable, thus set permissions to 0444.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/leds/led-class.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 69e7d86..2606600 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -74,7 +74,7 @@ static ssize_t led_max_brightness_show(struct device *dev,
>  
>  static struct device_attribute led_class_attrs[] = {
>  	__ATTR(brightness, 0644, led_brightness_show, led_brightness_store),
> -	__ATTR(max_brightness, 0644, led_max_brightness_show, NULL),
> +	__ATTR(max_brightness, 0444, led_max_brightness_show, NULL),
>  #ifdef CONFIG_LEDS_TRIGGERS
>  	__ATTR(trigger, 0644, led_trigger_show, led_trigger_store),
>  #endif

Queued in the leds tree, thanks.

Richard

