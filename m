Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab2J3Awk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 20:52:40 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49827 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2J3Awi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 20:52:38 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 29 Oct 2012 17:52:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jean Delvare <khali@linux-fr.org>, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: da9055: Fix chan_mux[DA9055_ADC_ADCIN3] setting
Message-ID: <20121030005246.GB19374@roeck-us.net>
References: <1351499678.14725.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351499678.14725.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 04:34:38PM +0800, Axel Lin wrote:
> Set chan_mux[DA9055_ADC_ADCIN3] = DA9055_ADC_MUX_ADCIN3.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi,
>   This looks like a typo, but I don't have a hardware to test it.
> Axel
>  drivers/hwmon/da9055-hwmon.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hwmon/da9055-hwmon.c b/drivers/hwmon/da9055-hwmon.c
> index 0b41f2c..3a3377c 100644
> --- a/drivers/hwmon/da9055-hwmon.c
> +++ b/drivers/hwmon/da9055-hwmon.c
> @@ -54,7 +54,7 @@ static const u8 chan_mux[DA9055_ADC_TJUNC + 1] = {
>  	[DA9055_ADC_VSYS]	= DA9055_ADC_MUX_VSYS,
>  	[DA9055_ADC_ADCIN1]	= DA9055_ADC_MUX_ADCIN1,
>  	[DA9055_ADC_ADCIN2]	= DA9055_ADC_MUX_ADCIN2,
> -	[DA9055_ADC_ADCIN3]	= DA9055_ADC_MUX_ADCIN1,
> +	[DA9055_ADC_ADCIN3]	= DA9055_ADC_MUX_ADCIN3,
>  	[DA9055_ADC_TJUNC]	= DA9055_ADC_MUX_T_SENSE,
>  };

Very much loks like a typo.

David, Ashish, any comments ? I would like to get your Ack before applying it.

Thanks,
Guenter
