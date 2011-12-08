Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1LHOIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:08:10 -0500
Received: from smtp-out-079.synserver.de ([212.40.185.79]:1228 "EHLO
	smtp-out-075.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751386Ab1LHOIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:08:06 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32723
Message-ID: <4EE0C4D8.4050106@metafoo.de>
Date: Thu, 08 Dec 2011 15:08:24 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: jz4740: Staticise jz4740_hwmon_driver
References: <1323351217.3398.0.camel@phoenix>
In-Reply-To: <1323351217.3398.0.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 02:33 PM, Axel Lin wrote:
> It is not used outside this driver so no need to make the symbol global.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks

> ---
>  drivers/hwmon/jz4740-hwmon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
> index 3d7e590..5253d23 100644
> --- a/drivers/hwmon/jz4740-hwmon.c
> +++ b/drivers/hwmon/jz4740-hwmon.c
> @@ -203,7 +203,7 @@ static int __devexit jz4740_hwmon_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -struct platform_driver jz4740_hwmon_driver = {
> +static struct platform_driver jz4740_hwmon_driver = {
>  	.probe	= jz4740_hwmon_probe,
>  	.remove = __devexit_p(jz4740_hwmon_remove),
>  	.driver = {


