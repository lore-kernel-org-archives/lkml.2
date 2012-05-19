Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab2ESSm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:42:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61523 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab2ESSmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:42:24 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/8] irqdomain: Kill off duplicate definitions.
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1337407908-7421-6-git-send-email-lethal@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org> <1337407908-7421-6-git-send-email-lethal@linux-sh.org>
Date: Sat, 19 May 2012 12:42:22 -0600
Message-Id: <20120519184222.8DFF23E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2012 15:11:45 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> Presently irqdomain.h has duplicate definitions for irq_find_host() and
> irq_set_default_host(), presumably from merge damage. Kill off the
> duplicates.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Applied, thanks.

g.

> ---
>  include/linux/irqdomain.h |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index a796dbf..5abb533 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -144,9 +144,6 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
>  
>  extern void irq_domain_remove(struct irq_domain *host);
>  
> -extern struct irq_domain *irq_find_host(struct device_node *node);
> -extern void irq_set_default_host(struct irq_domain *host);
> -
>  extern unsigned int irq_create_mapping(struct irq_domain *host,
>  				       irq_hw_number_t hwirq);
>  extern void irq_dispose_mapping(unsigned int virq);
> -- 
> 1.7.9.rc0.28.g0e1cf
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
