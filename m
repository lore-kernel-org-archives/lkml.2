Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab1JNRgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:36:20 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61574 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab1JNRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:36:18 -0400
Message-ID: <4E987310.1050401@pobox.com>
Date: Fri, 14 Oct 2011 13:36:16 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] ata_piix: CodingStyle fixes
References: <201110131543.30235.bzolnier@gmail.com>
In-Reply-To: <201110131543.30235.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 09:43 AM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] ata_piix: CodingStyle fixes
>
> CodingStyle fixes for piix_port_info[].
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/ata_piix.c |   68 ++++++++++++++-----------------------------------
>   1 file changed, 20 insertions(+), 48 deletions(-)
>
> Index: b/drivers/ata/ata_piix.c
> ===================================================================
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -473,131 +473,103 @@ static const struct piix_map_db *piix_ma
>   };
>
>   static struct ata_port_info piix_port_info[] = {
> -	[piix_pata_mwdma] = 	/* PIIX3 MWDMA only */
> -	{
> +	[piix_pata_mwdma] = {	/* PIIX3 MWDMA only */
>   		.flags		= PIIX_PATA_FLAGS,
>   		.pio_mask	= ATA_PIO4,
> -		.mwdma_mask	= ATA_MWDMA12_ONLY, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
> +		.mwdma_mask	= ATA_MWDMA12_ONLY, /* check if MWDMA0 is OK */
>   		.port_ops	=&piix_pata_ops,
>   	},

Having been the perpetrator of this "awful" coding style, I think it is 
fine and more readable as-is...  :)


