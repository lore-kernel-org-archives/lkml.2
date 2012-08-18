Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab2HRXXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 19:23:09 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50588 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab2HRXXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 19:23:06 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 18 Aug 2012 16:23:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        James.Bottomley@HansenPartnership.com, Andi Kleen <ak@linux.intel.com>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH 14/31] sections: Fix section conflicts in drivers/hwmon
Message-ID: <20120818232304.GA19997@roeck-us.net>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
 <1345311022-26328-15-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345311022-26328-15-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 10:30:05AM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Applied.

Looks like you did not include maintainers and/or subject mailing lists in your
patch series, so I guess you won't get much feedback.

Guenter

> ---
>  drivers/hwmon/coretemp.c |    2 +-
>  drivers/hwmon/w83627hf.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index faa16f8..0fa356f 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -196,7 +196,7 @@ struct tjmax {
>  	int tjmax;
>  };
>  
> -static struct tjmax __cpuinitconst tjmax_table[] = {
> +static const struct tjmax __cpuinitconst tjmax_table[] = {
>  	{ "CPU D410", 100000 },
>  	{ "CPU D425", 100000 },
>  	{ "CPU D510", 100000 },
> diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
> index ab48252..5b1a6a6 100644
> --- a/drivers/hwmon/w83627hf.c
> +++ b/drivers/hwmon/w83627hf.c
> @@ -1206,7 +1206,7 @@ static int __init w83627hf_find(int sioaddr, unsigned short *addr,
>  	int err = -ENODEV;
>  	u16 val;
>  
> -	static const __initdata char *names[] = {
> +	static __initconst char *const names[] = {
>  		"W83627HF",
>  		"W83627THF",
>  		"W83697HF",
> -- 
> 1.7.7.6
> 
> 
