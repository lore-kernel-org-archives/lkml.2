Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2IUMbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:31:00 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57710 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab2IUMa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:30:59 -0400
Date: Fri, 21 Sep 2012 13:30:56 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: remove vma arg from page_evictable
Message-ID: <20120921123056.GC11157@csn.ul.ie>
References: <alpine.LSU.2.00.1209182045370.11632@eggly.anvils>
 <alpine.LSU.2.00.1209182052030.11632@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1209182052030.11632@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 08:53:45PM -0700, Hugh Dickins wrote:
> page_evictable(page, vma) is an irritant: almost all its callers pass
> NULL for vma.  Remove the vma arg and use mlocked_vma_newpage(vma, page)
> explicitly in the couple of places it's needed.  But in those places we
> don't even need page_evictable() itself!  They're dealing with a freshly
> allocated anonymous page, which has no "mapping" and cannot be mlocked yet.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Ying Han <yinghan@google.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
