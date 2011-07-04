Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab1GDVwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 17:52:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53925 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab1GDVwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 17:52:46 -0400
Date: Mon, 4 Jul 2011 23:52:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
Message-ID: <20110704215240.GG15637@one.firstfloor.org>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com> <1309766525-14089-2-git-send-email-ming.m.lin@intel.com> <1309778192.3282.27.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309778192.3282.27.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 01:16:32PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-07-04 at 08:02 +0000, Lin Ming wrote:
> > +#define MEM_STORE_DCU_HIT              (1ULL << 0)
> 
> I'm pretty sure that's not Dublin City University, but what is it?
> Data-Cache-Unit? 

Yes

> what does that mean, L1/L2 or also L3? 

DCU is L1D

(L2 would be MLC, L3 is LLC in Intelnese)

> > +#define MEM_STORE_STLB_HIT             (1ULL << 1)
> 
> What's an sTLB? I know iTLB and dTLB's but sTLBs I've not heard of yet.

Second Level TLB (for both i and d)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
