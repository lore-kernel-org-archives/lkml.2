Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2BVGQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:16:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50177 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2BVGQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:16:22 -0500
Date: Wed, 22 Feb 2012 07:16:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        tim.c.chen@linux.intel.com
Subject: Re: [PATCH v2 00/22] mm: lru_lock splitting
Message-ID: <20120222061618.GT7703@one.firstfloor.org>
References: <20120220171138.22196.65847.stgit@zurg> <m2boor33g8.fsf@firstfloor.org> <4F447904.90500@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F447904.90500@openvz.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 09:11:32AM +0400, Konstantin Khlebnikov wrote:
> Andi Kleen wrote:
> >Konstantin Khlebnikov<khlebnikov@openvz.org>  writes:
> >
> >Konstantin,
> >
> >>There complete patch-set with my lru_lock splitting
> >>plus all related preparations and cleanups rebased to next-20120210
> >
> >On large systems we're also seeing lock contention on the lru_lock
> >without using memcgs. Any thoughts how this could be extended for this
> >situation too?
> 
> We can split lru_lock by pfn-based interleaving.
> After all these cleanups it is very easy. I already have patch for this.

Cool. If you send it can try it out on a large system.

This would split the LRU by pfn too, correct?

-Andi
