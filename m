Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab1DTH4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 03:56:15 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:20600 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1DTH4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:56:14 -0400
Date: Wed, 20 Apr 2011 09:55:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.39-rc3] lpc: irq and pci_ids patch for Intel Panther
 Point DeviceIDs
Message-ID: <20110420095552.7cb4b2d9@endymion.delvare>
In-Reply-To: <201104191635.16141.seth.heasley@intel.com>
References: <201104191635.16141.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 16:35:15 -0700, Seth Heasley wrote:
> This patch adds the LPC Controller DeviceIDs for the Intel Panther Point PCH.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

> 
> --- linux-2.6.39-rc3/include/linux/pci_ids.h.orig	2011-04-11 
> 17:21:51.000000000 -0700
> +++ linux-2.6.39-rc3/include/linux/pci_ids.h	2011-03-29 15:55:13.000000000 
> -0700
> @@ -2480,6 +2480,9 @@
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS	0x1c22
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN	0x1c41
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
> +#define PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS	0x1e22
> +#define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MIN	0x1e40
> +#define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX	0x1e5f
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS	0x1d22
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0	0x1d40
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1	0x1d41
> --- linux-2.6.39-rc3/arch/x86/pci/irq.c.orig	2011-04-11 17:21:51.000000000 
> -0700
> +++ linux-2.6.39-rc3/arch/x86/pci/irq.c	2011-04-14 12:15:47.000000000 -0700
> @@ -602,7 +602,9 @@
>  	||  (device >= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN && 
>  	     device <= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX)
>  	||  (device >= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN &&
> -	     device <= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX)) {
> +	     device <= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX)
> +	||  (device >= PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MIN &&
> +	     device <= PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX)) {
>  		r->name = "PIIX/ICH";
>  		r->get = pirq_piix_get;
>  		r->set = pirq_piix_set;


-- 
Jean Delvare
