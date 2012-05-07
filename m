Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab2EGSW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:22:57 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49947 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab2EGSW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:22:56 -0400
Date: Mon, 07 May 2012 14:21:43 -0400 (EDT)
Message-Id: <20120507.142143.172247040163546224.davem@davemloft.net>
To: tj@kernel.org
Cc: hannes@cmpxchg.org, akpm@linux-foundation.org, shangw@linux.vnet.ibm.com,
        yinghai@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] mm: remove sparsemem allocation details from the
 bootmem allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120507181941.GF19417@google.com>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
	<1336390672-14421-11-git-send-email-hannes@cmpxchg.org>
	<20120507181941.GF19417@google.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 07 May 2012 11:21:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Mon, 7 May 2012 11:19:41 -0700

> On Mon, May 07, 2012 at 01:37:52PM +0200, Johannes Weiner wrote:
>> alloc_bootmem_section() derives allocation area constraints from the
>> specified sparsemem section.  This is a bit specific for a generic
>> memory allocator like bootmem, though, so move it over to sparsemem.
>> 
>> As __alloc_bootmem_node_nopanic() already retries failed allocations
>> with relaxed area constraints, the fallback code in sparsemem.c can be
>> removed and the code becomes a bit more compact overall.
>> 
>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> For 03-10
> 
>  Acked-by: Tejun Heo <tj@kernel.org>
> 
> Thanks for doing this.  While at it, maybe we can clear up the naming
> mess there?  I don't hate __s too much but the bootmem allocator
> brings it to a whole new level.  :(

+1  And you can add my Ack to this series too, thanks Johannes:

Acked-by: David S. Miller <davem@davemloft.net>
