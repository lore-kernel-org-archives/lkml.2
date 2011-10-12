Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1JLKtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 06:49:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51790 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1JLKtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 06:49:24 -0400
Message-ID: <4E957080.6020102@mvista.com>
Date: Wed, 12 Oct 2011 14:48:32 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pata_sil680: minor CodingStyle fixups
References: <201110112021.51236.bzolnier@gmail.com>
In-Reply-To: <201110112021.51236.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-10-2011 22:21, Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_sil680: minor CodingStyle fixups

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_sil680.c |   58 ++++++++++++++++++++++++++--------------------
>   1 file changed, 33 insertions(+), 25 deletions(-)

> Index: b/drivers/ata/pata_sil680.c
> ===================================================================
> --- a/drivers/ata/pata_sil680.c
> +++ b/drivers/ata/pata_sil680.c
[...]
> @@ -265,12 +266,19 @@ static u8 sil680_init_chip(struct pci_de
>   	pci_write_config_dword(pdev, 0xB8, 0x43924392);
>   	pci_write_config_dword(pdev, 0xBC, 0x40094009);
>
> -	switch(tmpbyte&  0x30) {
> -		case 0x00: printk(KERN_INFO "sil680: 100MHz clock.\n");break;
> -		case 0x10: printk(KERN_INFO "sil680: 133MHz clock.\n");break;
> -		case 0x20: printk(KERN_INFO "sil680: Using PCI clock.\n");break;
> -		/* This last case is _NOT_ ok */
> -		case 0x30: printk(KERN_ERR "sil680: Clock disabled ?\n");
> +	switch (tmpbyte&  0x30) {
> +	case 0x00:
> +		printk(KERN_INFO "sil680: 100MHz clock.\n");
> +		break;
> +	case 0x10:
> +		printk(KERN_INFO "sil680: 133MHz clock.\n");
> +		break;
> +	case 0x20:
> +		printk(KERN_INFO "sil680: Using PCI clock.\n");
> +		break;

    pr_info() here and above?

> +	/* This last case is _NOT_ ok */
> +	case 0x30:
> +		printk(KERN_ERR "sil680: Clock disabled ?\n");

    pr_err()? Or checkpatch.pl doesn't complain about it (I forgot)?

WBR, Sergei
