Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2EGSId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:08:33 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:60491 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2EGSIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:08:32 -0400
Date: Mon, 7 May 2012 11:08:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 02/10] mm: bootmem: remove redundant offset check when
 finally freeing bootmem
Message-ID: <20120507180828.GE19417@google.com>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
 <1336390672-14421-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336390672-14421-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 01:37:44PM +0200, Johannes Weiner wrote:
> When bootmem releases an unaligned BITS_PER_LONG pages chunk of memory
> to the page allocator, it checks the bitmap if there are still
> unreserved pages in the chunk (set bits), but also if the offset in
> the chunk indicates BITS_PER_LONG loop iterations already.
> 
> But since the consulted bitmap is only a one-word-excerpt of the full
> per-node bitmap, there can not be more than BITS_PER_LONG bits set in
> it.  The additional offset check is unnecessary.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
