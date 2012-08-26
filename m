Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2HZSXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:23:12 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60855 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034Ab2HZSXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:23:10 -0400
Date: Sun, 26 Aug 2012 20:23:08 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 13/19] x86, io-apic: Move CONFIG_IRQ_REMAP code out of
 x86 core
Message-ID: <20120826182308.GE3690@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-14-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-14-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:55:59PM +0200, Joerg Roedel wrote:
> index fc89a2a..c84403e 100644
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -127,6 +127,7 @@ struct irq_cfg {
>  	u8			vector;
>  	u8			move_in_progress : 1;
>  #ifdef CONFIG_IRQ_REMAP
> +	bool			remapped;
  	u8			remapped : 1;
?

>  	union {
>  		struct irq_2_iommu irq_2_iommu;
>  		struct irq_2_irte  irq_2_irte;

Sebastian
