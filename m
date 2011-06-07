Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1FGJ5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:57:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49202 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1FGJ5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:57:54 -0400
Date: Tue, 7 Jun 2011 10:57:49 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix ENOSPC returned by handle_mm_fault()
Message-ID: <20110607095749.GD4372@csn.ul.ie>
References: <20110605134317.GF11521@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1106051141570.5792@sister.anvils>
 <20110605195025.GH11521@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1106051339001.8317@sister.anvils>
 <20110605221344.GJ11521@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1106052145370.17285@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1106052145370.17285@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 10:03:13PM -0700, Hugh Dickins wrote:
> Al Viro observes that in the hugetlb case, handle_mm_fault() may return
> a value of the kind ENOSPC when its caller is expecting a value of the
> kind VM_FAULT_SIGBUS: fix alloc_huge_page()'s failure returns.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Acked-by: Al Viro <viro@zeniv.linux.org.uk>
> Cc: stable@kernel.org

Nicely spotted!

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
