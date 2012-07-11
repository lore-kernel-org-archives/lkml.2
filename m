Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab2GKT3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:29:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19207 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2GKT3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:29:34 -0400
Date: Wed, 11 Jul 2012 15:21:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xensource.com, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: add desc_equal() to compare GDT descriptors
Message-ID: <20120711192101.GA10062@phenom.dumpdata.com>
References: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com>
 <1341830348-15529-4-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341830348-15529-4-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 11:39:07AM +0100, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> ---
>  arch/x86/include/asm/desc.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
> index 8bf1c06..d26f059 100644
> --- a/arch/x86/include/asm/desc.h
> +++ b/arch/x86/include/asm/desc.h
> @@ -85,6 +85,12 @@ static inline int desc_empty(const void *ptr)
>  	return !(desc[0] | desc[1]);
>  }
>  
> +static inline bool desc_equal(const struct desc_struct *d1,
> +			      const struct desc_struct *d2)
> +{
> +	return d1->a == d2->a && d1->b == d2->b;
> +}
> +
>  #ifdef CONFIG_PARAVIRT
>  #include <asm/paravirt.h>
>  #else
> -- 
> 1.7.2.5
