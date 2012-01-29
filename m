Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab2A2FRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 00:17:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:65108 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab2A2FRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 00:17:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100765246"
Date: Sun, 29 Jan 2012 13:07:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] readahead: add /debug/readahead/stats
Message-ID: <20120129050722.GC26244@localhost>
References: <20120127030524.854259561@intel.com>
 <20120127031327.159293683@intel.com>
 <alpine.DEB.2.00.1201271006480.16756@router.home>
 <20120127121551.acd256aa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127121551.acd256aa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 12:15:51PM -0800, Andrew Morton wrote:

> > The accounting code will be compiled in by default
> > (CONFIG_READAHEAD_STATS=y), and will remain inactive by default.
> 
> I agree with those choices.  They effectively mean that the stats will
> be a developer-only/debugger-only thing.  So even if the atomic_inc()
> costs are measurable during these develop/debug sessions, is anyone
> likely to care?

Sorry I have changed the default to CONFIG_READAHEAD_STATS=n to avoid
bloating the kernel (and forgot to edit the changelog accordingly).

I'm not sure how many people are going to check the readahead stats.

Thanks,
Fengguang
