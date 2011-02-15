Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1BOJnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:43:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44908 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab1BOJnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:43:40 -0500
Date: Tue, 15 Feb 2011 10:43:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        shaohui.zheng@intel.com, rientjes@google.com, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk registration
Message-ID: <20110215094327.GA1387@elte.hu>
References: <AANLkTin0C2AhtHm6K0av2N4pQxLvK_Fc+4w12Qg_QRkZ@mail.gmail.com>
 <20110214161249.GV18742@htj.dyndns.org>
 <AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com>
 <20110214162247.GX18742@htj.dyndns.org>
 <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com>
 <20110214182718.GB18742@htj.dyndns.org>
 <4D597D56.5060408@kernel.org>
 <20110214193050.GC18742@htj.dyndns.org>
 <4D5983EA.4020103@kernel.org>
 <20110215091103.GC3160@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215091103.GC3160@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> On Mon, Feb 14, 2011 at 11:35:06AM -0800, Yinghai Lu wrote:
> > On 02/14/2011 11:30 AM, Tejun Heo wrote:
> > > On Mon, Feb 14, 2011 at 11:07:02AM -0800, Yinghai Lu wrote:
> > >> Never mind. will send out patch after your patches get merged into tip.
> > > 
> > > Alright, fair enough.
> > > 
> > >> BTW, you may need to rebase your on top of tip/master.
> > > 
> > > Yeah, I saw a new patch going into the numa branch, but shouldn't this
> > > and the next series based on x86/numa?  That was how it was done with
> > > the previous series.
> > 
> > there is patch about init_memory_mapping_high() in tip/x86/bootmem.
> > it will put pgtable on local nodes.
> 
> Ingo, hpa, how do you guys want to handle this?  Maybe you can cherry
> pick or pull the branch into x86/numa?

Would be nice to have a version against the latest tip:x86/numa tree, the current 
one conflicts in arch/x86/mm/numa_64.c with your tree. Also, i suspect you want to 
propagate Yinghai's Acked-by's into the commits?

Thanks,

	Ingo
