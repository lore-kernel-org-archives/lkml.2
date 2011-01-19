Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1ASO4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 09:56:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:54261 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab1ASO4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 09:56:49 -0500
Date: Wed, 19 Jan 2011 15:56:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] Add forward declaration of struct device
In-Reply-To: <201012201723.30133.eike-kernel@sf-tec.de>
Message-ID: <alpine.LNX.2.00.1101191556190.26685@pobox.suse.cz>
References: <201012201723.30133.eike-kernel@sf-tec.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010, Rolf Eike Beer wrote:

> This fixes this warning when including linux/dmapool.h first:
> 
> warning: ‘struct device’ declared inside parameter list
> warning: its scope is only this definition or declaration, which is probably not what you want

In what situation do you see this warning? (the one you have posted 
doesn't show the filename that is being compiled).

> 
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> ---
>  include/linux/dmapool.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/dmapool.h b/include/linux/dmapool.h
> index 022e34f..52456aa 100644
> --- a/include/linux/dmapool.h
> +++ b/include/linux/dmapool.h
> @@ -14,6 +14,8 @@
>  #include <asm/io.h>
>  #include <asm/scatterlist.h>
>  
> +struct device;
> +
>  struct dma_pool *dma_pool_create(const char *name, struct device *dev, 
>  			size_t size, size_t align, size_t allocation);
>  

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
