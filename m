Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1BVVih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:38:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41301 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1BVVig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:38:36 -0500
Date: Tue, 22 Feb 2011 13:37:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andres Salomon <dilinger@queued.net>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] spi/spi_altera: fix build error
Message-Id: <20110222133739.d3e8da25.randy.dunlap@oracle.com>
In-Reply-To: <20110222132303.6a78b8e0@queued.net>
References: <20110222132303.6a78b8e0@queued.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D642CC6.02A3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 13:23:03 -0800 Andres Salomon wrote:

> I ran into a build error while attempting to build the Feb 22nd
> linux-next tree.
> 
> 
> 
> From: Andres Salomon <dilinger@queued.net>
> 
> Fix the following build error due to a missing semicolon:
> 
>  CC [M]  drivers/spi/spi_altera.o
> drivers/spi/spi_altera.c:308: error: expected ‘,’ or ‘;’ before ‘extern’
> make[2]: *** [drivers/spi/spi_altera.o] Error 1
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

so ignore my combined patch.  Thanks.


> ---
>  drivers/spi/spi_altera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi_altera.c b/drivers/spi/spi_altera.c
> index 5e001f3..4813a63 100644
> --- a/drivers/spi/spi_altera.c
> +++ b/drivers/spi/spi_altera.c
> @@ -304,7 +304,7 @@ static int __devexit altera_spi_remove(struct platform_device *dev)
>  static const struct of_device_id altera_spi_match[] = {
>  	{ .compatible = "ALTR,spi-1.0", },
>  	{},
> -}
> +};
>  MODULE_DEVICE_TABLE(of, altera_spi_match);
>  #else /* CONFIG_OF */
>  #define altera_spi_match NULL
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
