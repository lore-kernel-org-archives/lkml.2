Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1GELy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:54:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:62801 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab1GELy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:54:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,478,1304319600"; 
   d="scan'208";a="23956328"
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1309778192.3282.27.camel@twins>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
	 <1309778192.3282.27.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jul 2011 19:54:20 +0800
Message-Id: <1309866860.2381.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 19:16 +0800, Peter Zijlstra wrote:
> On Mon, 2011-07-04 at 08:02 +0000, Lin Ming wrote:
> > +#define MEM_STORE_DCU_HIT              (1ULL << 0)
> 
> I'm pretty sure that's not Dublin City University, but what is it?
> Data-Cache-Unit? what does that mean, L1/L2 or also L3? 
> 
> > +#define MEM_STORE_STLB_HIT             (1ULL << 1)
> 
> What's an sTLB? I know iTLB and dTLB's but sTLBs I've not heard of yet.
> 
> > +#define MEM_STORE_LOCKED_ACCESS                (1ULL << 2) 
> 
> Presumably that's about LOCK'ed ops?
> 
> So now you're just tacking bits on the end without even attempting to
> generalize/unify things, not charmed at all.

Any idea on the more useful store bits encoding?

Thanks,
Lin Ming


