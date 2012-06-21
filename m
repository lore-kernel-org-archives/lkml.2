Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab2FUVcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:32:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760347Ab2FUVcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:32:14 -0400
Message-ID: <4FE39290.8020609@redhat.com>
Date: Thu, 21 Jun 2012 17:30:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH 01/17] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
References: <1340192652-31658-1-git-send-email-mgorman@suse.de> <1340192652-31658-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1340192652-31658-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 07:43 AM, Mel Gorman wrote:

> +/* Clears ac->pfmemalloc if no slabs have pfmalloc set */
> +static void check_ac_pfmemalloc(struct kmem_cache *cachep,
> +						struct array_cache *ac)
> +{

> +	pfmemalloc_active = false;
> +out:
> +	spin_unlock_irqrestore(&l3->list_lock, flags);
> +}

The comment and the function do not seem to match.

Otherwise, the patch looks reasonable.
