Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab2DJX0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:26:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48659 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2DJX0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:26:50 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] irq_domain: correct the debugfs file name
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, benh@kernel.crashing.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
In-Reply-To: <1334060743-7901-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1334060743-7901-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 10 Apr 2012 17:26:47 -0600
Message-Id: <20120410232647.ACB273E081E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012 15:25:42 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> The actual name of the irq_domain mapping debugfs file is
> "irq_domain_mapping" not "virq_mapping".
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied, thanks

.g

> ---
>  kernel/irq/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
> index cf1a4a6..d1a758b 100644
> --- a/kernel/irq/Kconfig
> +++ b/kernel/irq/Kconfig
> @@ -62,7 +62,7 @@ config IRQ_DOMAIN_DEBUG
>  	help
>  	  This option will show the mapping relationship between hardware irq
>  	  numbers and Linux irq numbers. The mapping is exposed via debugfs
> -	  in the file "virq_mapping".
> +	  in the file "irq_domain_mapping".
>  
>  	  If you don't know what this means you don't need it.
>  
> -- 
> 1.7.9.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
