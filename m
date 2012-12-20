Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2LTBUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:20:14 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52929 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2LTBUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:20:09 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/3] gpio-langwell: update pci device table
To: David Cohen <david.a.cohen@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        David Cohen <david.a.cohen@intel.com>
In-Reply-To: <1355881933-15182-3-git-send-email-david.a.cohen@intel.com>
References: <1355881933-15182-1-git-send-email-david.a.cohen@intel.com> <1355881933-15182-3-git-send-email-david.a.cohen@intel.com>
Date: Thu, 20 Dec 2012 01:20:05 +0000
Message-Id: <20121220012005.2C0193E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012 17:52:12 -0800, David Cohen <david.a.cohen@intel.com> wrote:
> This patch adds Cloverview ids to pci device table.
> 
> Signed-off-by: David Cohen <david.a.cohen@intel.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-langwell.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
> index 8220c04..dc534a9 100644
> --- a/drivers/gpio/gpio-langwell.c
> +++ b/drivers/gpio/gpio-langwell.c
> @@ -231,6 +231,8 @@ static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f), .driver_data = 64 },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081f), .driver_data = 96 },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081a), .driver_data = 96 },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x08eb), .driver_data = 96 },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x08f7), .driver_data = 96 },
>  	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, lnw_gpio_ids);
> -- 
> 1.7.10.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
