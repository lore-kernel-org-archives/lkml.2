Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1GHNG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:06:56 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:40177 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1GHNGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:06:55 -0400
Date: Fri, 8 Jul 2011 17:06:50 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Ken O'Brien" <kernel@kenobrien.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: Fix style error in Macros
Message-ID: <20110708130649.GA29056@oksana.dev.rtsoft.ru>
References: <1306691592-29453-1-git-send-email-kernel@kenobrien.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1306691592-29453-1-git-send-email-kernel@kenobrien.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 06:53:12PM +0100, Ken O'Brien wrote:
> Two Macros in the changed file contained complex expressions which were not
> enclosed by parentheses.
> 
> Signed-off-by: Ken O'Brien <kernel@kenobrien.org>
> ---

Appled, thanks.

>  drivers/power/apm_power.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
> index dc628cb..8a612de 100644
> --- a/drivers/power/apm_power.c
> +++ b/drivers/power/apm_power.c
> @@ -14,11 +14,11 @@
>  #include <linux/apm-emulation.h>
>  
>  
> -#define PSY_PROP(psy, prop, val) psy->get_property(psy, \
> -			 POWER_SUPPLY_PROP_##prop, val)
> +#define PSY_PROP(psy, prop, val) (psy->get_property(psy, \
> +			 POWER_SUPPLY_PROP_##prop, val))
>  
> -#define _MPSY_PROP(prop, val) main_battery->get_property(main_battery, \
> -							 prop, val)
> +#define _MPSY_PROP(prop, val) (main_battery->get_property(main_battery, \
> +							 prop, val))
>  
>  #define MPSY_PROP(prop, val) _MPSY_PROP(POWER_SUPPLY_PROP_##prop, val)
