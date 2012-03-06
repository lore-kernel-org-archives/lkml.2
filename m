Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab2CFKRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:17:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59456 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab2CFKRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:17:06 -0500
Message-ID: <4F55E412.5050409@ti.com>
Date: Tue, 6 Mar 2012 11:16:50 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Shubhrajyoti D <shubhrajyoti@ti.com>
CC: <spi-devel-general@lists.sourceforge.net>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] spi/omap: Trivial cleanup
References: <1330524246-8864-1-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1330524246-8864-1-git-send-email-shubhrajyoti@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shubhro,

On 2/29/2012 3:04 PM, Shubhrajyoti D wrote:
> The context is stored directly inside drvdata structure post
> [f887876 spi/omap: Remove bus_num usage for instance index].
> Remove the OMAP2_MCSPI_MAX_CTRL macro as it is not needed anymore.
>
> Cc: Benoit Cousson<b-cousson@ti.com>
> Signed-off-by: Shubhrajyoti D<shubhrajyoti@ti.com>

Thanks for that extra cleanup, I missed it.

Acked-by: Benoit Cousson <b-cousson@ti.com>

> ---
> Applies on Benoit's for_3.4/dt_spi_eth
>
>   drivers/spi/spi-omap2-mcspi.c |    3 ---
>   1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index d1eb26c..3526281 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -45,9 +45,6 @@
>
>   #define OMAP2_MCSPI_MAX_FREQ		48000000
>
> -/* OMAP2 has 3 SPI controllers, while OMAP3 has 4 */
> -#define OMAP2_MCSPI_MAX_CTRL 		4
> -

I guess it can be included in the "spi/omap: Remove bus_num usage for 
instance index"?
Is that OK for you?


Thanks,
Benoit

