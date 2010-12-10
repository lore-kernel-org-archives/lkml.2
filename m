Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0LJVGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:06:54 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:49019 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752024Ab0LJVGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:06:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=T9KQ+nsJpbyx/aI9FvNb/zUqCzC+3dD3JqfMIDpwFWWQGMCivuBH/945Y6ddiMC5Ue6L6To7P5chwzHlDqVIUI63ZFsMn8ct8K9V3O181RCEY97wQYUuEvI+XzmcqJky;
Date: Fri, 10 Dec 2010 13:06:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.37-rc2] irq: irq and pci_ids patch for Intel
 Patsburg
Message-ID: <20101210130649.33a31b8a@jbarnes-desktop>
In-Reply-To: <201011171112.08712.seth.heasley@intel.com>
References: <201011171112.08712.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 12:12:08 -0700
Seth Heasley <seth.heasley@intel.com> wrote:

> This patch adds an additional LPC Controller DeviceID for the Intel Patsburg PCH.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.37-rc2/include/linux/pci_ids.h.orig	2010-11-17 10:00:31.000000000 -0800
> +++ linux-2.6.37-rc2/include/linux/pci_ids.h	2010-11-17 10:01:49.000000000 -0800
> @@ -2466,7 +2466,8 @@
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN	0x1c41
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS	0x1d22
> -#define PCI_DEVICE_ID_INTEL_PATSBURG_LPC	0x1d40
> +#define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0	0x1d40
> +#define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1	0x1d41
>  #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
>  #define PCI_DEVICE_ID_INTEL_82801AA_1	0x2411
>  #define PCI_DEVICE_ID_INTEL_82801AA_3	0x2413
> --- linux-2.6.37-rc2/arch/x86/pci/irq.c.orig	2010-11-17 10:01:13.000000000 -0800
> +++ linux-2.6.37-rc2/arch/x86/pci/irq.c	2010-11-17 10:01:33.000000000 -0800
> @@ -589,7 +589,8 @@
>  	case PCI_DEVICE_ID_INTEL_ICH10_1:
>  	case PCI_DEVICE_ID_INTEL_ICH10_2:
>  	case PCI_DEVICE_ID_INTEL_ICH10_3:
> -	case PCI_DEVICE_ID_INTEL_PATSBURG_LPC:
> +	case PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0:
> +	case PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1:
>  		r->name = "PIIX/ICH";
>  		r->get = pirq_piix_get;
>  		r->set = pirq_piix_set;
> 

applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
