Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2HZSQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:16:07 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60840 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439Ab2HZSQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:16:06 -0400
Date: Sun, 26 Aug 2012 20:16:03 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 10/19] x86, io_apic: Introduce function pointer for
 setup_timer_IRQ0_pin
Message-ID: <20120826181603.GC3690@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-11-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-11-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:55:56PM +0200, Joerg Roedel wrote:
> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> index 827f8a1..71824fc 100644
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -87,11 +87,18 @@ error:
>  	return ret;
>  }
>  
> +static void __init irq_remapping_setup_timer_pin(unsigned int ioapic_idx,
> +						 unsigned int pin, int vector)
> +{
> +	/* Not needed with interrupt remapping */

I see that this is not needed because it is empty. But *why* isn't it needed?
That comment would make sense here. So please drop this or explain :)

> +}
> +

Sebastian
