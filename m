Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0IKI5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 04:57:19 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13364 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab0IKI5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 04:57:18 -0400
Date: Sat, 11 Sep 2010 10:57:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2.6.35.4] irq: irq and pci_ids patch for Intel Patsburg
 DeviceIDs
Message-ID: <20100911105706.75c74a26@hyperion.delvare>
In-Reply-To: <201009101636.39962.seth.heasley@intel.com>
References: <201003251611.37706.seth.heasley@intel.com>
	<201009101636.39962.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Fri, 10 Sep 2010 16:36:39 -0700, Seth Heasley wrote:
> This patch adds the LPC Controller DeviceIDs for the Intel Patsburg PCH.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.35.4/include/linux/pci_ids.h.orig	2010-08-26 16:47:12.000000000 -0700
> +++ linux-2.6.35.4/include/linux/pci_ids.h	2010-09-10 16:34:06.000000000 -0700
> @@ -2423,6 +2423,7 @@
>  #define PCI_DEVICE_ID_INTEL_CPT_SMBUS	0x1c22
>  #define PCI_DEVICE_ID_INTEL_CPT_LPC_MIN	0x1c41
>  #define PCI_DEVICE_ID_INTEL_CPT_LPC_MAX	0x1c5f
> +#define PCI_DEVICE_ID_INTEL_PBG_LPC	0x1d40
>  #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
>  #define PCI_DEVICE_ID_INTEL_82801AA_1	0x2411
>  #define PCI_DEVICE_ID_INTEL_82801AA_3	0x2413
> --- linux-2.6.35.4/arch/x86/pci/irq.c.orig	2010-08-26 16:47:12.000000000 -0700
> +++ linux-2.6.35.4//arch/x86/pci/irq.c	2010-09-10 16:30:39.000000000 -0700
> @@ -589,6 +589,7 @@
>  	case PCI_DEVICE_ID_INTEL_ICH10_1:
>  	case PCI_DEVICE_ID_INTEL_ICH10_2:
>  	case PCI_DEVICE_ID_INTEL_ICH10_3:
> +	case PCI_DEVICE_ID_INTEL_PBG_LPC:
>  		r->name = "PIIX/ICH";
>  		r->get = pirq_piix_get;
>  		r->set = pirq_piix_set;

Could Intel please stop using abbreviations for their chip names? If
the chip is named Patsburg then please use PATSBURG in the symbol names
too. MRST, PGB, etc. make me sick.

Thanks,
-- 
Jean Delvare
