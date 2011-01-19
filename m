Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1ASEOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 23:14:55 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:47309 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab1ASEOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 23:14:55 -0500
Message-ID: <4D3665C3.5080604@wytron.com.tw>
Date: Wed, 19 Jan 2011 12:17:07 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Chou <thomas@wytron.com.tw>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-mtd@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd/of: allow MTD_OF_PARTS and MTD_PHYSMAP_OF config
 to others
References: <1295408639-14742-1-git-send-email-thomas@wytron.com.tw>
In-Reply-To: <1295408639-14742-1-git-send-email-thomas@wytron.com.tw>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 11:43 AM, Thomas Chou wrote:
> As devicetree support is added to more arch, these config should
> be allowed to other arch.

Please ignore this patch, as it is already fixed by Rob Herring.

- Thomas


>
> Signed-off-by: Thomas Chou<thomas@wytron.com.tw>
> ---
>   drivers/mtd/Kconfig      |    2 +-
>   drivers/mtd/maps/Kconfig |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
> index 1e2cbf5..b1f7689 100644
> --- a/drivers/mtd/Kconfig
> +++ b/drivers/mtd/Kconfig
> @@ -159,7 +159,7 @@ config MTD_AFS_PARTS
>
>   config MTD_OF_PARTS
>   	tristate "Flash partition map based on OF description"
> -	depends on (MICROBLAZE || PPC_OF)&&  MTD_PARTITIONS
> +	depends on OF&&  MTD_PARTITIONS
>   	help
>   	  This provides a partition parsing function which derives
>   	  the partition map from the children of the flash node,
> diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
> index a0dd7bb..5d37d31 100644
> --- a/drivers/mtd/maps/Kconfig
> +++ b/drivers/mtd/maps/Kconfig
> @@ -72,7 +72,7 @@ config MTD_PHYSMAP_BANKWIDTH
>
>   config MTD_PHYSMAP_OF
>   	tristate "Flash device in physical memory map based on OF description"
> -	depends on (MICROBLAZE || PPC_OF)&&  (MTD_CFI || MTD_JEDECPROBE || MTD_ROM)
> +	depends on OF&&  (MTD_CFI || MTD_JEDECPROBE || MTD_ROM)
>   	help
>   	  This provides a 'mapping' driver which allows the NOR Flash and
>   	  ROM driver code to communicate with chips which are mapped

