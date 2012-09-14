Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2INNUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:20:14 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32340 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab2INNUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:20:09 -0400
Date: Fri, 14 Sep 2012 09:09:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: arnd@arndb.de, linux@arm.linux.org.uk, catalin.marinas@arm.com,
        linaro-dev@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        tim@xen.org, Ian.Campbell@citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 24/24] MAINTAINERS: add myself as Xen ARM maintainer
Message-ID: <20120914130913.GL25249@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
 <1347621207-11294-24-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347621207-11294-24-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:13:26PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> ---
>  MAINTAINERS |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fdc0119..3d38291 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7752,6 +7752,13 @@ F:	drivers/xen/
>  F:	arch/x86/include/asm/xen/
>  F:	include/xen/
>  
> +XEN HYPERVISOR ARM
> +M:	Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> +L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> +S:	Supported
> +F:	arch/arm/xen/
> +F:	arch/arm/include/asm/xen/
> +
>  XEN NETWORK BACKEND DRIVER
>  M:	Ian Campbell <ian.campbell@citrix.com>
>  L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
> -- 
> 1.7.2.5
