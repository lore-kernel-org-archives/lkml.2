Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0KJOie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:38:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44939 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab0KJOia (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 10 Nov 2010 09:38:30 -0500
Date: Wed, 10 Nov 2010 09:37:26 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Mark XEN lists subscribers-only
Message-ID: <20101110143725.GA19218@dumpdata.com>
References: <1289380840.28590.132.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289380840.28590.132.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 01:20:40AM -0800, Joe Perches wrote:
> Standardize mailing address address at the same time.
>  
> Signed-off-by: Joe Perches <joe@perches.com>

Ok, stuck it in my branch for rcX bug-fixes.

> ---
>  MAINTAINERS |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0094224..70604d5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6598,14 +6598,14 @@ F:	drivers/platform/x86
>  
>  XEN PCI SUBSYSTEM
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> -L:	xen-devel@lists.xensource.com
> +L:	xen-devel@lists.xensource.com (subscribers-only)
>  S:	Supported
>  F:	arch/x86/pci/*xen*
>  F:	drivers/pci/*xen*
>  
>  XEN SWIOTLB SUBSYSTEM
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> -L:	xen-devel@lists.xensource.com
> +L:	xen-devel@lists.xensource.com (subscribers-only)
>  S:	Supported
>  F:	arch/x86/xen/*swiotlb*
>  F:	drivers/xen/*swiotlb*
> @@ -6613,7 +6613,7 @@ F:	drivers/xen/*swiotlb*
>  XEN HYPERVISOR INTERFACE
>  M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> -L:	xen-devel@lists.xen.org
> +L:	xen-devel@lists.xensource.com (subscribers-only)
>  L:	virtualization@lists.osdl.org
>  S:	Supported
>  F:	arch/x86/xen/
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
