Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0JTRM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:12:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24663 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab0JTRM5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 20 Oct 2010 13:12:57 -0400
Date: Wed, 20 Oct 2010 13:11:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, chrisw@sous-sol.org
Subject: Re: [PATCH] MAINTAINERS: Add myself to the Xen Hypervisor
 Interface and remove Chris Wright.
Message-ID: <20101020171133.GA31634@dumpdata.com>
References: <1287594145-20781-1-git-send-email-konrad.wilk@oracle.com>
 <1287594145-20781-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287594145-20781-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CC-ing Chris.

On Wed, Oct 20, 2010 at 01:02:25PM -0400, Konrad Rzeszutek Wilk wrote:
> Chris is working on other stuff now, and I am working full-time
> with Jeremy on these bits.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Acked-by: Chris Wright <chrisw@sous-sol.org>
> ---
>  MAINTAINERS |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dd8bbe0..59e9999 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6507,10 +6507,10 @@ F:	arch/x86/xen/*swiotlb*
>  F:	drivers/xen/*swiotlb*
>  
>  XEN HYPERVISOR INTERFACE
> -M:	Jeremy Fitzhardinge <jeremy@xensource.com>
> -M:	Chris Wright <chrisw@sous-sol.org>
> +M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> +M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> +L:	xen-devel@lists.xen.org
>  L:	virtualization@lists.osdl.org
> -L:	xen-devel@lists.xensource.com
>  S:	Supported
>  F:	arch/x86/xen/
>  F:	drivers/*/xen-*front.c
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
