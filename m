Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0KJPRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:17:21 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:40059 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756199Ab0KJPRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:17:20 -0500
Date: Wed, 10 Nov 2010 15:17:19 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 2/2] perf stat: Use event group to simulate PMI on
	PMI-less hardware counter
Message-ID: <20101110151719.GA21453@console-pimps.org>
References: <1289369725.2430.39.camel@minggr.sh.intel.com> <1289391709.2191.102.camel@laptop> <1289400319.2479.39.camel@localhost> <1289400784.2191.134.camel@laptop> <1289401597.2479.48.camel@localhost> <1289401723.2084.0.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289401723.2084.0.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 04:08:43PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-10 at 23:06 +0800, Lin Ming wrote:
> > > The proposed idea was to group with a software hrtimer-based event
> > > and use the hrtimer's sample to read the hardware group sibling using
> > > PERF_SAMPLE_READ.
> > 
> > So this is usefull in perf top/record on PMI-less counter?
> 
> Correct, Matt was implementing this.

My work in progress is here,

http://git.kernel.org/?p=linux/kernel/git/mfleming/sh-2.6.git;a=commitdiff;h=68f95e18cec7b2bc6baf3731969f94b9c51c7a08

I'll try get this submitted by the beginning of next week.
