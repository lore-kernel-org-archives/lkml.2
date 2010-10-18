Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0JRA0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 20:26:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44242 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab0JRA0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 20:26:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: Re: [PATCH 11/16] mm: fixed typos
Cc: kosaki.motohiro@jp.fujitsu.com, gelma@gelma.net, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <1287235165-27841-11-git-send-email-andrea.gelmini@gelma.net>
References: <1287235165-27841-1-git-send-email-andrea.gelmini@gelma.net> <1287235165-27841-11-git-send-email-andrea.gelmini@gelma.net>
Message-Id: <20101018092415.3AD1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Oct 2010 09:26:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  mm/percpu.c |    2 +-
>  mm/vmscan.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index c76ef38..8b9aa45 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -31,7 +31,7 @@
>   * as small as 4 bytes.  The allocator organizes chunks into lists
>   * according to free size and tries to allocate from the fullest one.
>   * Each chunk keeps the maximum contiguous area size hint which is
> - * guaranteed to be eqaul to or larger than the maximum contiguous
> + * guaranteed to be equal to or larger than the maximum contiguous
>   * area in the chunk.  This helps the allocator not to iterate the
>   * chunk maps unnecessarily.
>   *
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c5dfabf..08823c4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -79,7 +79,7 @@ struct scan_control {
>  	int order;
>  
>  	/*
> -	 * Intend to reclaim enough contenious memory rather than to reclaim
> +	 * Intend to reclaim enough contiguous memory rather than to reclaim
>  	 * enough amount memory. I.e, it's the mode for high order allocation.
>  	 */
>  	bool lumpy_reclaim_mode;

Please cc lkml and linux-mm when you post any patch. (I've added them)
but anyway, this looks good.

thanks.


