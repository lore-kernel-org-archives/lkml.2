Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab0IYLaw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 07:30:52 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:35251 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab0IYLav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 07:30:51 -0400
Date: Sat, 25 Sep 2010 13:30:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 2.6.35.4] irq: irq and pci_ids patch for Intel
Message-ID: <20100925133039.75e9ac71@endymion.delvare>
In-Reply-To: <201009241606.11840.seth.heasley@intel.com>
References: <201009241606.11840.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 16:06:11 -0700, Seth Heasley wrote:
> >> Could Intel please stop using abbreviations for their chip names? If
> >> the chip is named Patsburg then please use PATSBURG in the symbol
> >names
> >> too. MRST, PGB, etc. make me sick.
> >
> >Agreed.  Do you want to submit a rename patch for the existing stuff?
> >You can do it on top of this one if you like, I'll put it into
> >linux-next.
> >
> >I guess this means more typing for you in future patches, Seth. :)
> >
> >Thanks,
> >--
> >Jesse Barnes, Intel Open Source Technology Center
> 
> Jesse,
> 
> I renamed some of the recent symbols, others to be renamed later on.  This patch was built against the previous changes.  
> 
> Jean,
> 
> Also included in the patch are changes to drivers/i2c/busses/i2c-i801.c, as the updated symbols are referenced there.  
> 
> Regards,
> -Seth
> -------------
> 
> This patch updates the defines for Intel devices in include/linux/pci_ids.h, referenced in arch/x86/pci/irq.c and drivers/i2c/busses/i2c-i801.c, reflecting approved legal branding, and using fuller code-names for products under development.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.35.4/include/linux/pci_ids.h.orig	2010-08-26 16:47:12.000000000 -0700
> +++ linux-2.6.35.4/include/linux/pci_ids.h	2010-09-24 13:56:47.000000000 -0700
> @@ -2420,9 +2420,10 @@
>  #define PCI_DEVICE_ID_INTEL_82840_HB	0x1a21
>  #define PCI_DEVICE_ID_INTEL_82845_HB	0x1a30
>  #define PCI_DEVICE_ID_INTEL_IOAT	0x1a38
> -#define PCI_DEVICE_ID_INTEL_CPT_SMBUS	0x1c22
> -#define PCI_DEVICE_ID_INTEL_CPT_LPC_MIN	0x1c41
> -#define PCI_DEVICE_ID_INTEL_CPT_LPC_MAX	0x1c5f
> +#define PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS	0x1c22
> +#define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN	0x1c41
> +#define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
> +#define PCI_DEVICE_ID_INTEL_PATSBURG_LPC	0x1d40
>  #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
>  #define PCI_DEVICE_ID_INTEL_82801AA_1	0x2411
>  #define PCI_DEVICE_ID_INTEL_82801AA_3	0x2413
> @@ -2628,9 +2629,9 @@
>  #define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
>  #define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
>  #define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
> -#define PCI_DEVICE_ID_INTEL_PCH_LPC_MIN	0x3b00
> -#define PCI_DEVICE_ID_INTEL_PCH_LPC_MAX	0x3b1f
> -#define PCI_DEVICE_ID_INTEL_PCH_SMBUS	0x3b30
> +#define PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MIN	0x3b00
> +#define PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MAX	0x3b1f
> +#define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
>  #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
>  #define PCI_DEVICE_ID_INTEL_5100_16	0x65f0
>  #define PCI_DEVICE_ID_INTEL_5100_21	0x65f5
> @@ -2639,8 +2640,8 @@
>  #define PCI_DEVICE_ID_INTEL_5400_FBD0	0x4035
>  #define PCI_DEVICE_ID_INTEL_5400_FBD1	0x4036
>  #define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
> -#define PCI_DEVICE_ID_INTEL_TOLAPAI_0	0x5031
> -#define PCI_DEVICE_ID_INTEL_TOLAPAI_1	0x5032
> +#define PCI_DEVICE_ID_INTEL_EP80579_0	0x5031
> +#define PCI_DEVICE_ID_INTEL_EP80579_1	0x5032
>  #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
>  #define PCI_DEVICE_ID_INTEL_82371SB_1	0x7010
>  #define PCI_DEVICE_ID_INTEL_82371SB_2	0x7020
> --- linux-2.6.35.4/arch/x86/pci/irq.c.orig	2010-09-24 13:59:39.000000000 -0700
> +++ linux-2.6.35.4/arch/x86/pci/irq.c	2010-09-24 14:02:07.000000000 -0700
> @@ -584,28 +584,28 @@
>  	case PCI_DEVICE_ID_INTEL_ICH9_3:
>  	case PCI_DEVICE_ID_INTEL_ICH9_4:
>  	case PCI_DEVICE_ID_INTEL_ICH9_5:
> -	case PCI_DEVICE_ID_INTEL_TOLAPAI_0:
> +	case PCI_DEVICE_ID_INTEL_EP80579_0:
>  	case PCI_DEVICE_ID_INTEL_ICH10_0:
>  	case PCI_DEVICE_ID_INTEL_ICH10_1:
>  	case PCI_DEVICE_ID_INTEL_ICH10_2:
>  	case PCI_DEVICE_ID_INTEL_ICH10_3:
> -	case PCI_DEVICE_ID_INTEL_PBG_LPC:
> +	case PCI_DEVICE_ID_INTEL_PATSBURG_LPC:
>  		r->name = "PIIX/ICH";
>  		r->get = pirq_piix_get;
>  		r->set = pirq_piix_set;
>  		return 1;
>  	}
>  
> -	if ((device >= PCI_DEVICE_ID_INTEL_PCH_LPC_MIN) && 
> -		(device <= PCI_DEVICE_ID_INTEL_PCH_LPC_MAX)) {
> +	if ((device >= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MIN) && 
> +		(device <= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MAX)) {
>  		r->name = "PIIX/ICH";
>  		r->get = pirq_piix_get;
>  		r->set = pirq_piix_set;
>  		return 1;
>  	}
>  
> -	if ((device >= PCI_DEVICE_ID_INTEL_CPT_LPC_MIN) && 
> -		(device <= PCI_DEVICE_ID_INTEL_CPT_LPC_MAX)) {
> +	if ((device >= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN) && 
> +		(device <= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX)) {
>  		r->name = "PIIX/ICH";
>  		r->get = pirq_piix_get;
>  		r->set = pirq_piix_set;
> --- linux-2.6.35.4/drivers/i2c/busses/Kconfig.orig	2010-09-24 14:59:23.000000000 -0700
> +++ linux-2.6.35.4/drivers/i2c/busses/Kconfig	2010-09-24 14:59:42.000000000 -0700
> @@ -95,7 +95,7 @@
>  	    ESB2
>  	    ICH8
>  	    ICH9
> -	    Tolapai
> +	    EP80579
>  	    ICH10
>  	    3400/5 Series (PCH)

How did this become "5_3400_SERIES" in the symbol names? Shouldn't it
be 3400_5_SERIES instead?

>  	    Cougar Point (PCH)
> --- linux-2.6.35.4/drivers/i2c/busses/i2c-i801.c.orig	2010-09-24 14:57:55.000000000 -0700
> +++ linux-2.6.35.4/drivers/i2c/busses/i2c-i801.c	2010-09-24 14:59:13.000000000 -0700
> @@ -38,7 +38,7 @@
>    82801G   (ICH7)       0x27da     32     hard     yes     yes     yes
>    82801H   (ICH8)       0x283e     32     hard     yes     yes     yes
>    82801I   (ICH9)       0x2930     32     hard     yes     yes     yes
> -  Tolapai               0x5032     32     hard     yes     yes     yes
> +  EP80579               0x5032     32     hard     yes     yes     yes

Maybe keep "Tolapai" inside parentheses, as people may know the
platform by that name by now?

>    ICH10                 0x3a30     32     hard     yes     yes     yes
>    ICH10                 0x3a60     32     hard     yes     yes     yes
>    3400/5 Series (PCH)   0x3b30     32     hard     yes     yes     yes
> @@ -587,11 +587,11 @@
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_17) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_5) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_6) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TOLAPAI_1) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_EP80579_1) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_4) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_5) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH_SMBUS) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CPT_SMBUS) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS) },
>  	{ 0, }
>  };

Other than these minor details, I'm very happy with this change:

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
