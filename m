Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab2JSRny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:43:54 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58455 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082Ab2JSRm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:42:57 -0400
Message-ID: <50817497.5070900@kernel.org>
Date: Fri, 19 Oct 2012 16:41:11 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: "cbou@mail.ru" <cbou@mail.ru>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] lp8788-charger: fix ADC channel names
References: <A874F61F95741C4A9BA573A70FE3998F64178F9F@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F64178F9F@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 07:11 AM, Kim, Milo wrote:
>  LP8788 IIO ADC driver and platform data have specific naming convention
>  for ADC channels. That is using prefix 'lp8788_'.
>  To keep this rule, ADC channel names are changed.
> 
It's a little unusual to name the consumer side of the map so specifically.
If you want to do so it's up to you though (and it obviously has to match)
that provided in platform_data including the default map in the iio driver.
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/power/lp8788-charger.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
> index 614e6aa..02fc9ab 100644
> --- a/drivers/power/lp8788-charger.c
> +++ b/drivers/power/lp8788-charger.c
> @@ -600,13 +600,13 @@ static void lp8788_setup_adc_channel(const char *consumer_name,
>  	struct iio_channel *chan;
>  	enum lp8788_adc_id id;
>  	const char *chan_name[LPADC_MAX] = {
> -		[LPADC_VBATT_5P5] = "vbatt-5p5",
> -		[LPADC_VBATT_6P0] = "vbatt-6p0",
> -		[LPADC_VBATT_5P0] = "vbatt-5p0",
> -		[LPADC_ADC1]      = "adc1",
> -		[LPADC_ADC2]      = "adc2",
> -		[LPADC_ADC3]      = "adc3",
> -		[LPADC_ADC4]      = "adc4",
> +		[LPADC_VBATT_5P5] = "lp8788_vbatt_5p5",
> +		[LPADC_VBATT_6P0] = "lp8788_vbatt_6p0",
> +		[LPADC_VBATT_5P0] = "lp8788_vbatt_5p0",
> +		[LPADC_ADC1]      = "lp8788_adc1",
> +		[LPADC_ADC2]      = "lp8788_adc2",
> +		[LPADC_ADC3]      = "lp8788_adc3",
> +		[LPADC_ADC4]      = "lp8788_adc4",
>  	};
>  
>  	if (!pdata)
> 
