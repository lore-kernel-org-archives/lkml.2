Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0C1RKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 13:10:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57274 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab0C1RKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 13:10:08 -0400
Message-ID: <4BAF8D6A.4000905@cs.helsinki.fi>
Date: Sun, 28 Mar 2010 20:10:02 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
Subject: Re: [PATCH 9/9] mm: Fix continuation lines
References: <cover.1269655208.git.joe@perches.com> <c53e66323c5898fe17221c0813779862189abce3.1269655209.git.joe@perches.com>
In-Reply-To: <c53e66323c5898fe17221c0813779862189abce3.1269655209.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.

> ---
>  mm/slab.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index a9f325b..ceb4e3a 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -4227,10 +4227,11 @@ static int s_show(struct seq_file *m, void *p)
>  		unsigned long node_frees = cachep->node_frees;
>  		unsigned long overflows = cachep->node_overflow;
>  
> -		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu \
> -				%4lu %4lu %4lu %4lu %4lu", allocs, high, grown,
> -				reaped, errors, max_freeable, node_allocs,
> -				node_frees, overflows);
> +		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu "
> +			   "%4lu %4lu %4lu %4lu %4lu",
> +			   allocs, high, grown,
> +			   reaped, errors, max_freeable, node_allocs,
> +			   node_frees, overflows);
>  	}
>  	/* cpu stats */
>  	{

