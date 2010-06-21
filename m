Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab0FUVOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:14:54 -0400
Received: from kroah.org ([198.145.64.141]:47480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758497Ab0FUVOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:14:53 -0400
Date: Mon, 21 Jun 2010 14:13:19 -0700
From: Greg KH <greg@kroah.com>
To: Ky Srinivasan <ksrinivasan@novell.com>
Cc: hpa@zytor.com, hjanssen@microsoft.com, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Hyperv: Export the symbol that tracks hyperv features
 and recommendations
Message-ID: <20100621211319.GA25447@kroah.com>
References: <4C1F80160200003000087BA8@sinclair.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1F80160200003000087BA8@sinclair.provo.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 03:07:02PM -0600, Ky Srinivasan wrote:
> 
>  
> From: K. Y. Srinivasan <ksrinivasan@novell.com>
> Subject:  Export the symbol  for hyperv drivers to access hyperv
> features and recommendations. This patch is needed by the hyperV clocksource driver.
> 
> Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
> 
> Index: linux.trees.git/arch/x86/kernel/cpu/mshyperv.c
> ===================================================================
> --- linux.trees.git.orig/arch/x86/kernel/cpu/mshyperv.c	2010-05-18 10:14:02.000000000 -0600
> +++ linux.trees.git/arch/x86/kernel/cpu/mshyperv.c	2010-05-18 14:12:11.000000000 -0600
> @@ -18,6 +18,7 @@
>  #include <asm/mshyperv.h>
>  
>  struct ms_hyperv_info ms_hyperv;
> +EXPORT_SYMBOL(ms_hyperv);

EXPORT_SYMBOL_GPL()?  Didn't you have it that way in your previous
patch?

thanks,

greg k-h
