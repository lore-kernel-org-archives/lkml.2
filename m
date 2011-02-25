Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab1BYI6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:58:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:50661 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab1BYI6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:58:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,224,1297065600"; 
   d="scan'208";a="891175792"
Subject: Re: [PATCH -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimP8h_rvJ6ejMy9Ys-3e8M3cbNGY6c3yRCgrGL+@mail.gmail.com>
References: <1298555968.2220.15.camel@localhost>
	 <1298556237.2220.19.camel@localhost>	<20110224165705.GA15498@elte.hu>
	 <1298624119.2835.87.camel@minggr.sh.intel.com>
	 <AANLkTimP8h_rvJ6ejMy9Ys-3e8M3cbNGY6c3yRCgrGL+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 16:59:06 +0800
Message-ID: <1298624346.2835.88.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 16:56 +0800, Stephane Eranian wrote:
> Lin,
> 
> I have a patch almost ready that updates the PEBS constraints for all CPUs.
> I'll add the SNB constraints as well.

Nice.

Thanks.

> 
> On Fri, Feb 25, 2011 at 9:55 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > On Fri, 2011-02-25 at 00:57 +0800, Ingo Molnar wrote:
> >> * Lin Ming <ming.m.lin@intel.com> wrote:
> >>
> >> > Adds SandyBridge support to perf.
> >>
> >> Wondering, have you tested things like PEBS? You can do it via:
> >>
> >>       perf record -e instructions:p -a sleep 10
> >>       perf top -e instructions:p
> >>
> >> ('p' stands for 'precise')
> >
> > Let me do more PEBS tests...
> >
> >>
> >> Also, please list known limitations in the changelog.
> >
> > OK.
> >
> >>
> >> Thanks,
> >>
> >>       Ingo
> >
> >
> >


