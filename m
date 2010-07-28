Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0G1TPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:15:33 -0400
Received: from shutemov.name ([188.40.19.243]:33078 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab0G1TPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:15:32 -0400
Date: Wed, 28 Jul 2010 22:15:31 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Russell King <linux@arm.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] arm/mach-ixp2000: Add missing comma - fix build failure
Message-ID: <20100728191531.GA10719@shutemov.name>
References: <201007282043.13561.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007282043.13561.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 08:43:13PM +0200, Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This trivial patch fixes a build failure [1] by adding a missing comma.

It has been fixed by updated patch:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6269/1

Thank you.

> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> KernelVersion: linux-next-20100728
> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2980895/
> 
> BF introduced by 3cad685d - ARM: 6253/1: Add 'code' parameter for
> hook_fault_code()
> 
>  arch/arm/mach-ixp2000/pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-ixp2000/pci.c b/arch/arm/mach-ixp2000/pci.c
> index 853fd90..f797c5f 100644
> --- a/arch/arm/mach-ixp2000/pci.c
> +++ b/arch/arm/mach-ixp2000/pci.c
> @@ -209,7 +209,7 @@ ixp2000_pci_preinit(void)
>  			"the needed workaround has not been configured in");
>  #endif
>  
> -	hook_fault_code(16+6, ixp2000_pci_abort_handler, SIGBUS, 0
> +	hook_fault_code(16+6, ixp2000_pci_abort_handler, SIGBUS, 0,
>  				"PCI config cycle to non-existent device");
>  }
>  
> -- 
> 1.7.1
> 

-- 
 Kirill A. Shutemov
