Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab0HaLZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:25:11 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38676 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932141Ab0HaLZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:25:09 -0400
Date: Tue, 31 Aug 2010 12:25:08 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH V2 0/4] Generalise ARM perf-events backend for oprofile
Message-ID: <20100831112508.GA27532@console-pimps.org>
References: <cover.1282848651.git.matt@console-pimps.org> <20100831110517.GE22783@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831110517.GE22783@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 01:05:17PM +0200, Robert Richter wrote:
> On 26.08.10 15:09:15, Matt Fleming wrote:
> > The perf-events backend for OProfile that Will Deacon wrote in
> > 8c1fc96f6fd1f361428ba805103af0d0eee65179 ("ARM: 6072/1: oprofile: use
> > perf-events framework as backend") is of use to more architectures
> > than just ARM. Move the code into drivers/oprofile/ so that SH can use
> > it instead of the nearly identical copy of its OProfile code.
> > 
> > The benefit of the backend is that it becomes necessary to only
> > maintain one copy of the PMU accessor functions for each architecture,
> > with bug fixes and new features benefiting both OProfile and perf.
> > 
> > Note that I haven't been able to test these patches on an ARM board to
> > see if I've caused any regressions. If anyone else could do that I'd
> > appreciate it. Though, I have been able to compile this version of the
> > series.
> > 
> > This patch series is based on tip/master.
> 
> Matt,
> 
> please rebase your next version of this patch set to
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> It contains Will's patches.

Sure, will do! Thanks.
