Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0J3IVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 04:21:48 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:24335 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0J3IVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 04:21:47 -0400
Date: Sat, 30 Oct 2010 10:21:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 4/6] hwmon: Change mail address of Hans J.
 Koch
Message-ID: <20101030102136.6a6a3035@endymion.delvare>
In-Reply-To: <20101029223223.GE4331@local>
References: <20101029221231.GA4331@local>
	<20101029223223.GE4331@local>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Sat, 30 Oct 2010 00:32:23 +0200, Hans J. Koch wrote:
> My old mail address doesn't exist anymore. This changes all occurrences
> to my new address.

Thanks for letting us know.

> 
> Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
> ---
>  drivers/hwmon/amc6821.c |    2 +-
>  drivers/hwmon/lm93.c    |    4 ++--
>  drivers/hwmon/max6650.c |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
> index fa9708c..4033974 100644
> --- a/drivers/hwmon/amc6821.c
> +++ b/drivers/hwmon/amc6821.c
> @@ -4,7 +4,7 @@
>  	Copyright (C) 2009 T. Mertelj <tomaz.mertelj@guest.arnes.si>
>  
>  	Based on max6650.c:
> -	Copyright (C) 2007 Hans J. Koch <hjk@linutronix.de>
> +	Copyright (C) 2007 Hans J. Koch <hjk@hansjkoch.de>
>  
>  	This program is free software; you can redistribute it and/or modify
>  	it under the terms of the GNU General Public License as published by
> diff --git a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c
> index 6669255..754e5fb 100644
> --- a/drivers/hwmon/lm93.c
> +++ b/drivers/hwmon/lm93.c
> @@ -20,7 +20,7 @@
>      Adapted to 2.6.20 by Carsten Emde <cbe@osadl.org>
>          Copyright (c) 2006 Carsten Emde, Open Source Automation Development Lab
>  
> -    Modified for mainline integration by Hans J. Koch <hjk@linutronix.de>
> +    Modified for mainline integration by Hans J. Koch <hjk@hansjkoch.de>
>          Copyright (c) 2007 Hans J. Koch, Linutronix GmbH
>  
>      This program is free software; you can redistribute it and/or modify
> @@ -2629,7 +2629,7 @@ static void __exit lm93_exit(void)
>  }
>  
>  MODULE_AUTHOR("Mark M. Hoffman <mhoffman@lightlink.com>, "
> -		"Hans J. Koch <hjk@linutronix.de");
> +		"Hans J. Koch <hjk@hansjkoch.de");

Probably the right time to add the missing ">". I'll do it, consider
this patch applied.

>  MODULE_DESCRIPTION("LM93 driver");
>  MODULE_LICENSE("GPL");
>  
> diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
> index a0160ee..9a11532 100644
> --- a/drivers/hwmon/max6650.c
> +++ b/drivers/hwmon/max6650.c
> @@ -2,7 +2,7 @@
>   * max6650.c - Part of lm_sensors, Linux kernel modules for hardware
>   *             monitoring.
>   *
> - * (C) 2007 by Hans J. Koch <hjk@linutronix.de>
> + * (C) 2007 by Hans J. Koch <hjk@hansjkoch.de>
>   *
>   * based on code written by John Morris <john.morris@spirentcom.com>
>   * Copyright (c) 2003 Spirent Communications


-- 
Jean Delvare
