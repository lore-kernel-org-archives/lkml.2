Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240Ab2KAK6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 06:58:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab2KAK6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 06:58:42 -0400
Date: Thu, 1 Nov 2012 10:58:38 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Ingo Molnar <mingo@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 11/31] mm/mpol: Make MPOL_LOCAL a real policy
Message-ID: <20121101105838.GR3888@suse.de>
References: <20121025121617.617683848@chello.nl>
 <20121025124833.322016965@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121025124833.322016965@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:16:28PM +0200, Peter Zijlstra wrote:
> Make MPOL_LOCAL a real and exposed policy such that applications that
> relied on the previous default behaviour can explicitly request it.
> 
> Requested-by: Christoph Lameter <cl@linux.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Seems reasonable but Michael Kerrisk should be cc'd because when the dust
settles on this there may be a manual page update required.

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
