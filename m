Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab2ESTIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 15:08:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55608 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab2ESTIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 15:08:11 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irq_domain: Document size parameter of irq_domain_add_linear()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1337426135-9807-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1337426135-9807-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Sat, 19 May 2012 13:08:09 -0600
Message-Id: <20120519190809.B1D483E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2012 12:15:35 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied,thanks.

g.

> ---
>  kernel/irq/irqdomain.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 0e0ba5f..d0e50eb 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -156,6 +156,7 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
>  /**
>   * irq_domain_add_linear() - Allocate and register a legacy revmap irq_domain.
>   * @of_node: pointer to interrupt controller's device tree node.
> + * @size: Number of interrupts in the domain.
>   * @ops: map/unmap domain callbacks
>   * @host_data: Controller private data pointer
>   */
> -- 
> 1.7.10
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
