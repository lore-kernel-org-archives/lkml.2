Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0HXSzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 14:55:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58053 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab0HXSzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 14:55:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QSo9amzm416R7Q9j4V9rb8uRHeojSkFQxOhIvMJAfbqYuB1UM1HzZktDr7MkHDUxp6
         OV4llO6GtedFBN/YxKE9bra5XhtyKQjyLzPk+qHlBvRu4kdcc/mS0hXUVi5Zjk2kZsQQ
         +IgjjNMXu4h6HpJDDC4Au5phYa0pE4sYBI940=
Date: Tue, 24 Aug 2010 22:54:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100824185458.GG5723@lenovo>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com> <20100820152510.GA4167@elte.hu> <20100823085339.GA26713@elte.hu> <20100824171504.GI26154@erda.amd.com> <20100824172806.GF5723@lenovo> <20100824184658.GB4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824184658.GB4879@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 02:46:58PM -0400, Don Zickus wrote:
> On Tue, Aug 24, 2010 at 09:28:06PM +0400, Cyrill Gorcunov wrote:
> > On Tue, Aug 24, 2010 at 07:15:05PM +0200, Robert Richter wrote:
> > > On 23.08.10 04:53:39, Ingo Molnar wrote:
> > > > Ok, to not hold up the perf/urgent flow i zapped these two commits for 
> > > > the time being:
> > > > 
> > > >  4a31beb: perf, x86: Fix handle_irq return values
> > > >  8e3e42b: perf, x86: Try to handle unknown nmis with an enabled PMU
> > > 
> > > Ingo, are those commits in some branch to fetch them for testing? I
> > > did not find them in tip/master.
> > > 
> > > Thanks,
> > > 
> > > -Robert
> > > 
> > > -- 
> > > Advanced Micro Devices, Inc.
> > > Operating System Research Center
> > >
> > 
> > Robert, they should be in -tip tree, I have
> > 
> > | commit 4a31bebe71ab2e4f6ecd6e5f9f2ac9f0ff38ff76
> > | Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > | Date:   Thu Aug 19 16:28:00 2010 +0200
> > |
> > |    perf, x86: Fix handle_irq return values
> 
> Has anyone else seen kernel panics when enabling the LOCKUP_DETECTOR or
> apply Robert's patch?  I keep getting a panic with unable to handle paging
> request everytime either Robert's patch or the lockup detector uses
> __get_cpu_var().  And only on 2.6.36 code.
> 
> Cheers,
> Don
> 

I use 2.6.34 atm. Letme try 2.6.36 (which might require some time to recompile).

	-- Cyrill
