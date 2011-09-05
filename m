Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1IEUOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 16:14:38 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:55978 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1IEUOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 16:14:33 -0400
Subject: Re: [PATCH 1/2] leds-class: change back LEDS_CLASS to tristate
 instead of bool
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm <akpm@linux-foundation.org>
In-Reply-To: <1315249786-15387-1-git-send-email-bryan.wu@canonical.com>
References: <1315249786-15387-1-git-send-email-bryan.wu@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 20:51:38 +0100
Message-ID: <1315252298.1243.21.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-06 at 03:09 +0800, Bryan Wu wrote:
> LEDS_CLASS is required by leds and trigger drivers, but we can build it
> as module. So change this option back as tristate and treak the help
> message as well.
> 
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>

Acked-by: Richard Purdie <rchard.purdie@linuxfoundation.org>

> ---
>  drivers/leds/Kconfig |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index b591e72..1c35927 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -17,10 +17,13 @@ menuconfig NEW_LEDS
>  if NEW_LEDS
>  
>  config LEDS_CLASS
> -	bool "LED Class Support"
> +	tristate "LED Class Support"
>  	help
>  	  This option enables the led sysfs class in /sys/class/leds.  You'll
> -	  need this to do anything useful with LEDs.  If unsure, say N.
> +	  need this to do anything useful with LEDs.  If unsure, say M.
> +
> +	  Note: don't disable it as N, because plenty of led and trigger drivers
> +	  are using this option.
>  
>  comment "LED drivers"
>  


