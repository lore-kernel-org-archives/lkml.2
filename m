Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3AFLi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 06:38:27 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55861 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3AFLi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 06:38:26 -0500
Message-ID: <50E96230.8010506@kernel.org>
Date: Sun, 06 Jan 2013 11:38:24 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] iio: lp8788_adc: fix parent device in kernel message
References: <A874F61F95741C4A9BA573A70FE3998F69E10FD3@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E10FD3@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 06:28 AM, Kim, Milo wrote:
> Use 'dev' of iio device in a kernel message rather than i2c client device node.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
added to togreg branch of iio.git

Thanks
> ---
>  drivers/iio/adc/lp8788_adc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/adc/lp8788_adc.c b/drivers/iio/adc/lp8788_adc.c
> index 4c9b0f7..f8bcb1f 100644
> --- a/drivers/iio/adc/lp8788_adc.c
> +++ b/drivers/iio/adc/lp8788_adc.c
> @@ -179,7 +179,7 @@ static int lp8788_iio_map_register(struct iio_dev *indio_dev,
>  
>  	ret = iio_map_array_register(indio_dev, map);
>  	if (ret) {
> -		dev_err(adc->lp->dev, "iio map err: %d\n", ret);
> +		dev_err(&indio_dev->dev, "iio map err: %d\n", ret);
>  		return ret;
>  	}
>  
> 
