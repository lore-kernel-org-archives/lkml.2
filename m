Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab2JCSSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:18:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46174 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524Ab2JCSR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:17:59 -0400
X-Sasl-enc: jvygHZSzh2WaUTihWOvcEv82gM6i/3E0giVPXtqdm2PA 1349288279
Date: Wed, 3 Oct 2012 11:17:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: arm@vger.kernel.org, djbw@fb.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: fix interrupt name issue with apb dma.
Message-ID: <20121003181757.GA24871@kroah.com>
References: <1349284687-22311-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349284687-22311-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 10:48:07PM +0530, Laxman Dewangan wrote:
> When watching the interrupts through /proc/interrupts,
> the name of the interrupts are blank or garbage. The
> reason is the pointer passed for devname during irq
> registration is stack and so it get changed after
> dma registration completes.
> Allocate the pointer as part of dma channel and pass
> this pointer as the devname for irq registration to
> avoid change of name.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/dma/tegra20-apb-dma.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
