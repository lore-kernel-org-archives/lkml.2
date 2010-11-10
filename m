Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab0KJOtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:49:40 -0500
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:63826 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756371Ab0KJOtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:49:05 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1289380840.28590.132.camel@Joe-Laptop>
References: <1289380840.28590.132.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 14:27:20 +0000
Message-ID: <1289399240.724.48.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] MAINTAINERS: Mark XEN lists subscribers-only
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=fd6gu-_BvqYA:10 a=IkcTkHD0fZMA:10 a=IJv9LcIfAAAA:8 a=yPCof4ZbAAAA:8 a=SEF7xSSsAAAA:8 a=tHz9FfFoAAAA:8 a=mLnsDVdbAAAA:8 a=dlI4R5ZWAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=liAA5opg9DaImOLo6IsA:9 a=UykPPTgvidHpO1TEjTcA:7 a=D47EOPkdHPV5_vW9sp5D-9SStFoA:4 a=QEXdDO2ut3YA:10 a=x8gzFH9gYPwA:10 a=K6kUPx8HyhEA:10 a=7DSvI1NPTFQA:10 a=6O0IECtVFhoA:10 a=viDM6Qac857pQ_Wh:21 a=oreaulfsZZ44oZs4:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AFAIK the Xen lists are "(moderated for non-subscribers)" rather than
"(subscribers-only)".

I think they also whitelist upon successful moderation but that doesn't
seem to normally be expressed in the MAINTAINERS file.

Ian.

On Wed, 2010-11-10 at 01:20 -0800, Joe Perches wrote:
> Standardize mailing address address at the same time.
>  
> Signed-off-by: Joe Perches <joe@perches.com>
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
> 

-- 
Ian Campbell
Current Noise: Wolf - Make Friends With Your Nightmares

Is it possible that software is not like anything else, that it is meant to
be discarded:  that the whole point is to always see it as a soap bubble?

