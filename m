Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab1LGTQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:16:48 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:60388 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656Ab1LGTQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:16:47 -0500
Date: Wed, 7 Dec 2011 20:16:37 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mark some messages as INFO
Message-ID: <20111207191637.GB12679@cmpxchg.org>
References: <1323277360-3155-1-git-send-email-teg@jklm.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323277360-3155-1-git-send-email-teg@jklm.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 06:02:40PM +0100, Tom Gundersen wrote:
> @@ -4913,31 +4913,31 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
>  	find_zone_movable_pfns_for_nodes(zone_movable_pfn);
>  
>  	/* Print out the zone ranges */
> -	printk("Zone PFN ranges:\n");
> +	printk(KERN_INFO "Zone PFN ranges:\n");
>  	for (i = 0; i < MAX_NR_ZONES; i++) {
>  		if (i == ZONE_MOVABLE)
>  			continue;
> -		printk("  %-8s ", zone_names[i]);
> +		printk(KERN_INFO "  %-8s ", zone_names[i]);
>  		if (arch_zone_lowest_possible_pfn[i] ==
>  				arch_zone_highest_possible_pfn[i])
> -			printk("empty\n");
> +			printk(KERN_INFO "empty\n");
>  		else
> -			printk("%0#10lx -> %0#10lx\n",
> +			printk(KERN_INFO "%0#10lx -> %0#10lx\n",
>  				arch_zone_lowest_possible_pfn[i],
>  				arch_zone_highest_possible_pfn[i]);
>  	}

Shouldn't continuation lines be KERN_CONT instead?
