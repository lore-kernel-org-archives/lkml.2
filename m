Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1BXOZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:25:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42548 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab1BXOZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:25:24 -0500
Date: Thu, 24 Feb 2011 15:25:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf: x86, add SandyBridge support
Message-ID: <20110224142523.GJ5818@one.firstfloor.org>
References: <1298555968.2220.15.camel@localhost> <20110224140214.GI5818@one.firstfloor.org> <1298556684.2220.26.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298556684.2220.26.camel@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 10:11:24PM +0800, Lin Ming wrote:
> On Thu, 2011-02-24 at 22:02 +0800, Andi Kleen wrote:
> > > +	[ C(OP_READ) ] = {
> > > +		[ C(RESULT_ACCESS) ] = 0x04d1, /* MEM_LOAD_UOPS_RETIRED.LLC_HIT */
> > > +		[ C(RESULT_MISS)   ] = 0x0,
> > > +	},
> > > +	[ C(OP_WRITE) ] = {
> > > +		[ C(RESULT_ACCESS) ] = 0x0424, /* L2_RQSTS.RFO_HITS */
> > > +		[ C(RESULT_MISS)   ] = 0x0824, /* L2_RQSTS.RFO_MISS */
> > 
> > No! You really need offcore here. L2 is not LLC!!!
> > See the offcore patchkit which fixes this for Nehalem.
> 
> Yes, I know that.
> But I write it like this for now since the offcore patchkit has not been
> merged yet.

It's just wrong. Please don't merge more bugs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
