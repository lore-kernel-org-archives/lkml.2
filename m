Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab0FQNs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 09:48:27 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:50256 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0FQNs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 09:48:26 -0400
Date: Thu, 17 Jun 2010 08:45:09 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: wzt.wzt@gmail.com
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, penberg@cs.helsinki.fi,
       mpm@selenic.com
Subject: Re: [PATCH] Slabinfo: Fix display format
In-Reply-To: <20100617155420.GB2693@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1006170844300.22997@router.home>
References: <20100617155420.GB2693@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, wzt.wzt@gmail.com wrote:

> @@ -4271,7 +4271,7 @@ static int s_show(struct seq_file *m, void *p)
>  	if (error)
>  		printk(KERN_ERR "slab: cache %s error: %s\n", name, error);
>
> -	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d",
> +	seq_printf(m, "%-27s %6lu %6lu %6u %4u %4d",
>  		   name, active_objs, num_objs, cachep->buffer_size,
>  		   cachep->num, (1 << cachep->gfporder));
>  	seq_printf(m, " : tunables %4u %4u %4u",

This one may break user space tools that have assumptions about the length
of the field. Or do tools not make that assumption?

