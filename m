Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762104Ab2FHQ6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:58:05 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:32805 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760689Ab2FHQ6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:58:01 -0400
Message-ID: <4FD22F0B.6090908@xenotime.net>
Date: Fri, 08 Jun 2012 09:57:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, t-kristo@ti.com
Subject: Re: [PATCH v2] MFD: twl6040: Update Kconfig to avoid build breakage
References: <1339145661-25333-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1339145661-25333-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 01:54 AM, Peter Ujfalusi wrote:

> twl6040 needs CONFIG_IRQ_DOMAIN to compile, without this we have:
> drivers/mfd/twl6040-irq.c: In function 'twl6040_irq_init':
> drivers/mfd/twl6040-irq.c:164:2: error: implicit declaration of function 'irq_domain_add_legacy'
> drivers/mfd/twl6040-irq.c:165:11: error: 'irq_domain_simple_ops' undeclared (first use in this function)
> drivers/mfd/twl6040-irq.c:165:11: note: each undeclared identifier is reported only once for each function it appears in
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/mfd/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index e129c82..92144ed 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -286,6 +286,7 @@ config TWL6040_CORE
>  	depends on I2C=y && GENERIC_HARDIRQS
>  	select MFD_CORE
>  	select REGMAP_I2C
> +	select IRQ_DOMAIN
>  	default n
>  	help
>  	  Say yes here if you want support for Texas Instruments TWL6040 audio



-- 
~Randy
