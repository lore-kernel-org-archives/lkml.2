Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab2EGSTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:19:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55264 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2EGSTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:19:45 -0400
Date: Mon, 7 May 2012 11:19:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] mm: remove sparsemem allocation details from the
 bootmem allocator
Message-ID: <20120507181941.GF19417@google.com>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
 <1336390672-14421-11-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336390672-14421-11-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 01:37:52PM +0200, Johannes Weiner wrote:
> alloc_bootmem_section() derives allocation area constraints from the
> specified sparsemem section.  This is a bit specific for a generic
> memory allocator like bootmem, though, so move it over to sparsemem.
> 
> As __alloc_bootmem_node_nopanic() already retries failed allocations
> with relaxed area constraints, the fallback code in sparsemem.c can be
> removed and the code becomes a bit more compact overall.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

For 03-10

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks for doing this.  While at it, maybe we can clear up the naming
mess there?  I don't hate __s too much but the bootmem allocator
brings it to a whole new level.  :(

-- 
tejun
