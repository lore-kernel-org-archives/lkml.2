Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1KXJV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:21:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab1KXJVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:21:54 -0500
Date: Thu, 24 Nov 2011 10:21:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Axel Lin <axel.lin@gmail.com>
cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] leds: Convert leds-dac124s085 to module_spi_driver
In-Reply-To: <1322122197.10476.5.camel@phoenix>
Message-ID: <Pine.LNX.4.64.1111241020400.14085@axis700.grange>
References: <1322122004.10476.1.camel@phoenix> <1322122197.10476.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:bQXeGBcF+BKuW8M89RieUnRNafL1Tr4M+SVOExVaqyu
 TBP85eAi4zzU0foDgvoPOy9+icJKPIKQ53HsZRDY9Hvx7v5tem
 ZHT5S/+SPqxHP7pPnw/sQUiMHCTmu8vBgsRpVhdqatJpJwkNVE
 dtUB3vM0qzMaEf6jqsRB1XnssMDBhNJFmwYFfAcpw+0yptxw/A
 dMCc+qxC2fu7yYVxtz1im5DbrloogterDq12HnUbtQz5ODmlbL
 azXHOoyWBX3UH3wUx4dfNKog/xs8xUUtPXMRLkr83IItOK5/PK
 8ZBnUkzs9E5zpjuYE8NuqVGwiVM3cUHXTdjdCIZ9IeR/7WNv3j
 v0AgD6sxT/Hd1SiqtAcsrZr0JZs+hc97vP3Jrj1vMysEuygQql
 ILF6I9V7zbqog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Nov 2011, Axel Lin wrote:

> Factor out some boilerplate code for spi driver registration
> into module_spi_driver.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/leds/leds-dac124s085.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/leds/leds-dac124s085.c b/drivers/leds/leds-dac124s085.c
> index 31cf0d6..d56c142 100644
> --- a/drivers/leds/leds-dac124s085.c
> +++ b/drivers/leds/leds-dac124s085.c
> @@ -131,18 +131,7 @@ static struct spi_driver dac124s085_driver = {
>  	},
>  };
>  
> -static int __init dac124s085_leds_init(void)
> -{
> -	return spi_register_driver(&dac124s085_driver);
> -}
> -
> -static void __exit dac124s085_leds_exit(void)
> -{
> -	spi_unregister_driver(&dac124s085_driver);
> -}
> -
> -module_init(dac124s085_leds_init);
> -module_exit(dac124s085_leds_exit);
> +module_spi_driver(dac124s085_driver);
>  
>  MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
>  MODULE_DESCRIPTION("DAC124S085 LED driver");
> -- 
> 1.7.5.4
> 
> 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
