Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1C1Go1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 02:44:27 -0400
Received: from imr3.ericy.com ([198.24.6.13]:36706 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab1C1Go0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 02:44:26 -0400
Date: Sun, 27 Mar 2011 23:43:33 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, J Keerthy <j-keerthy@ti.com>,
        Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/3] hwmon: twl4030-madc-hwmon: add "platform:" prefix
 for platform modalias
Message-ID: <20110328064333.GA3890@ericsson.com>
References: <1299466949.3879.0.camel@mola>
 <1299467133.3879.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1299467133.3879.5.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 11:05:33AM +0800, Axel Lin wrote:
> Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
> with "platform:"), the platform modalias is prefixed with "platform:".
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Cc: J Keerthy <j-keerthy@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>

Looks like this fell through the cracks. Applied.

Thanks,
Guenter

> ---
>  drivers/hwmon/twl4030-madc-hwmon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/twl4030-madc-hwmon.c b/drivers/hwmon/twl4030-madc-hwmon.c
> index 97e22be..de58191 100644
> --- a/drivers/hwmon/twl4030-madc-hwmon.c
> +++ b/drivers/hwmon/twl4030-madc-hwmon.c
> @@ -154,4 +154,4 @@ module_exit(twl4030_madc_hwmon_exit);
>  MODULE_DESCRIPTION("TWL4030 ADC Hwmon driver");
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("J Keerthy");
> -MODULE_ALIAS("twl4030_madc_hwmon");
> +MODULE_ALIAS("platform:twl4030_madc_hwmon");
> -- 
> 1.7.2
> 
> 
> 
> 
