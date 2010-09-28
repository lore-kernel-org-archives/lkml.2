Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0I1LlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 07:41:19 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:61004 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102Ab0I1LlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 07:41:19 -0400
Message-ID: <4CA1D44B.4080900@metafoo.de>
Date: Tue, 28 Sep 2010 13:40:59 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 2/3] drivers/power: add missing kfree(jz_battery) in	jz_battery_remove()
References: <1285571232.31251.1.camel@mola> <1285571311.31251.3.camel@mola>
In-Reply-To: <1285571311.31251.3.camel@mola>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-By: Lars-Peter Clausen <lars@metafoo.de>

> ---
>  drivers/power/jz4740-battery.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
> index 20c4b95..a8108a7 100644
> --- a/drivers/power/jz4740-battery.c
> +++ b/drivers/power/jz4740-battery.c
> @@ -383,6 +383,7 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
>  
>  	iounmap(jz_battery->base);
>  	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
> +	kfree(jz_battery);
>  
>  	return 0;
>  }

Thanks
- Lars
