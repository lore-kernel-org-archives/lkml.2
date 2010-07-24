Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0GXK4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 06:56:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57595 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab0GXK4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 06:56:48 -0400
Date: Sat, 24 Jul 2010 12:56:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [2.6.35-rc6] quiesce EDAC initialisation on desktop/mobile i7
Message-ID: <20100724105642.GA8059@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <AANLkTin5f_mfe+Jjo7Uv0mLyoQzM3KR3FK5=ejjTg=7D@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTin5f_mfe+Jjo7Uv0mLyoQzM3KR3FK5=ejjTg=7D@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel J Blueman <daniel.blueman@gmail.com>
Date: Fri, Jul 23, 2010 at 11:16:52PM +0100

> Hi Linus,
> 
> A small fixlet for 2.6.35-rc7/final.
> 
> ---
> 
> Don't print failure to detect Core i7 EDAC facilities to the console at boot
> time, most often occurring on Core i7 desktops and laptops.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> 
> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
> index cc9357d..e0187d1 100644
> --- a/drivers/edac/i7core_edac.c
> +++ b/drivers/edac/i7core_edac.c
> @@ -1300,7 +1300,7 @@ int i7core_get_onedevice(struct pci_dev **prev, int devno,
>  		if (devno == 0)
>  			return -ENODEV;
> 
> -		i7core_printk(KERN_ERR,
> +		i7core_printk(KERN_INFO,
>  			"Device not found: dev %02x.%d PCI ID %04x:%04x\n",
>  			dev_descr->dev, dev_descr->func,
>  			PCI_VENDOR_ID_INTEL, dev_descr->dev_id);
>

Adding the driver maintainer to CC. Please, try doing that in the
future,

Thanks.

-- 
Regards/Gruss,
    Boris.
