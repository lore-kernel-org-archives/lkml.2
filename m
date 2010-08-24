Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0HXSrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 14:47:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab0HXSr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 14:47:29 -0400
Date: Tue, 24 Aug 2010 14:46:58 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100824184658.GB4879@redhat.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
 <20100824171504.GI26154@erda.amd.com>
 <20100824172806.GF5723@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824172806.GF5723@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 09:28:06PM +0400, Cyrill Gorcunov wrote:
> On Tue, Aug 24, 2010 at 07:15:05PM +0200, Robert Richter wrote:
> > On 23.08.10 04:53:39, Ingo Molnar wrote:
> > > Ok, to not hold up the perf/urgent flow i zapped these two commits for 
> > > the time being:
> > > 
> > >  4a31beb: perf, x86: Fix handle_irq return values
> > >  8e3e42b: perf, x86: Try to handle unknown nmis with an enabled PMU
> > 
> > Ingo, are those commits in some branch to fetch them for testing? I
> > did not find them in tip/master.
> > 
> > Thanks,
> > 
> > -Robert
> > 
> > -- 
> > Advanced Micro Devices, Inc.
> > Operating System Research Center
> >
> 
> Robert, they should be in -tip tree, I have
> 
> | commit 4a31bebe71ab2e4f6ecd6e5f9f2ac9f0ff38ff76
> | Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> | Date:   Thu Aug 19 16:28:00 2010 +0200
> |
> |    perf, x86: Fix handle_irq return values

Has anyone else seen kernel panics when enabling the LOCKUP_DETECTOR or
apply Robert's patch?  I keep getting a panic with unable to handle paging
request everytime either Robert's patch or the lockup detector uses
__get_cpu_var().  And only on 2.6.36 code.

Cheers,
Don
