Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0KJSap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:30:45 -0500
Received: from smtp.citrix.com ([66.165.176.89]:45256 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab0KJSao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:30:44 -0500
X-IronPort-AV: E=Sophos;i="4.59,179,1288584000"; 
   d="scan'208";a="11054584"
Subject: Re: [PATCH V2] MAINTAINERS: Mark XEN lists as moderated
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
In-Reply-To: <1289411271.15905.78.camel@Joe-Laptop>
References: <1289380840.28590.132.camel@Joe-Laptop>
	 <1289399240.724.48.camel@zakaz.uk.xensource.com>
	 <1289399731.28590.136.camel@Joe-Laptop>
	 <1289401042.724.54.camel@zakaz.uk.xensource.com>
	 <1289401337.15905.1.camel@Joe-Laptop>
	 <1289410745.724.56.camel@zakaz.uk.xensource.com>
	 <1289411271.15905.78.camel@Joe-Laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 10 Nov 2010 18:30:38 +0000
Message-ID: <1289413838.14738.6.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 09:47 -0800, Joe Perches wrote:
> Standardize list email address at the same time.
>  
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Ian Campbell <Ian.Campbell@citrix.com>

> ---
> On Wed, 2010-11-10 at 17:39 +0000, Ian Campbell wrote:
> > It's been confirmed, non-subscribers are moderated for xen-devel.
> 
> changes from v1: Mark as moderated instead of subscribers-only
> 
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
> +L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
>  S:	Supported
>  F:	arch/x86/pci/*xen*
>  F:	drivers/pci/*xen*
>  
>  XEN SWIOTLB SUBSYSTEM
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> -L:	xen-devel@lists.xensource.com
> +L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
>  S:	Supported
>  F:	arch/x86/xen/*swiotlb*
>  F:	drivers/xen/*swiotlb*
> @@ -6613,7 +6613,7 @@ F:	drivers/xen/*swiotlb*
>  XEN HYPERVISOR INTERFACE
>  M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> -L:	xen-devel@lists.xen.org
> +L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
>  L:	virtualization@lists.osdl.org
>  S:	Supported
>  F:	arch/x86/xen/
> 
> 
> 


