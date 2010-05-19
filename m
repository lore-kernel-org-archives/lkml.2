Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0ESRDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:03:36 -0400
Received: from kroah.org ([198.145.64.141]:59800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab0ESRDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:03:35 -0400
Date: Wed, 19 May 2010 10:03:25 -0700
From: Greg KH <greg@kroah.com>
To: Ky Srinivasan <ksrinivasan@novell.com>
Cc: hpa@zytor.com, hjanssen@microsoft.com, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Hyperv: Export the symbol that tracks hyperv features
 and recommendations
Message-ID: <20100519170325.GA21306@kroah.com>
References: <4BE49778.6060800@zytor.com>
 <tip-e08cae4181af9483b04ecfac48f01c8e5a5f27bf@git.kernel.org>
 <4BF3C35A02000030000855F1@sinclair.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF3C35A02000030000855F1@sinclair.provo.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 10:54:18AM -0600, Ky Srinivasan wrote:
> 
> From: K. Y. Srinivasan <ksrinivasan@novell.com>
> Subject:  Export the symbol  for hyperv drivers to access hyperv
> features and recommendations.
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

EXPORT_SYMBOL_GPL() perhaps?

thanks,

greg k-h
