Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab1D2P1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:27:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:64402 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab1D2P1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:27:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,288,1301900400"; 
   d="scan'208";a="635883460"
Date: Fri, 29 Apr 2011 08:27:36 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110429152736.GA6517@tassilo.jf.intel.com>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 11:04:46AM -0400, Vince Weaver wrote:
> Hello Linus
> 
> can you revert the commit b52c55c6a25e4515b5e075a989ff346fc251ed09

Acked-by: Andi Kleen <ak@linux.intel.com>

(I wrote the original patch)

> (finally!) added in the 2.6.39 merge window.  However this is a useful 
> feature and many tools (including the PAPI performance counter library 
> that I work on) had added support for it in anticipation of the 2.6.39 

I also use some tools which benefit from this functionality. The
extended raw events are very useful to analyze NUMA problems for once.

-Andi
