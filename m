Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1EYMJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:09:49 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:55126 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab1EYMJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:09:48 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya <tomoya-linux@dsn.okisemi.com>
Subject: Re: pch_gpio: Support new device ML7223
Date: Wed, 25 May 2011 14:09:46 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r2; KDE/4.6.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
References: <1304938729-10609-1-git-send-email-tomoya-linux@dsn.okisemi.com>
In-Reply-To: <1304938729-10609-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105251409.47309.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomoya,

On Monday 09 May 2011 12:58:49 Tomoya wrote:
> diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
> index f970a5f..36919e7 100644
> --- a/drivers/gpio/pch_gpio.c
> +++ b/drivers/gpio/pch_gpio.c
> @@ -283,8 +283,10 @@ static int pch_gpio_resume(struct pci_dev *pdev)
>  #define pch_gpio_resume NULL
>  #endif
> 
> +#define PCI_VENDOR_ID_ROHM             0x10DB

Should this be moved to pci_ids.h?

>  static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },

Likewise for the product ID. While at it, the ID for EG20T could also be moved 
in a separate patch.

>  	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);

Regards,
Alexander
