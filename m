Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab0FIKvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:51:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60579 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab0FIKvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:51:19 -0400
Date: Wed, 9 Jun 2010 11:50:59 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/28] mm: Improve page_lock_anon_vma() comment
Message-ID: <20100609105059.GB5650@csn.ul.ie>
References: <20100607110654.606530953@chello.nl> <20100607111406.592305581@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100607111406.592305581@chello.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 01:06:56PM +0200, Peter Zijlstra wrote:
> A slightly more verbose comment to go along with the trickery in
> page_lock_anon_vma().
> 
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <1271158226.4807.1107.camel@twins>
> ---
>  mm/rmap.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 

Acked-by: Mel Gorman <mel@csn.ul.ie>

> <SNIP>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
