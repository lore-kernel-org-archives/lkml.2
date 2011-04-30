Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772Ab1D3VEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 17:04:22 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:57367 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab1D3VEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 17:04:21 -0400
Date: Sat, 30 Apr 2011 17:03:51 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Borislav Petkov <bp@alien8.de>
cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
In-Reply-To: <20110430081132.GA3705@liondog.tnic>
Message-ID: <alpine.DEB.2.00.1104301659230.8618@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu> <20110429164227.GA25491@elte.hu> <alpine.DEB.2.00.1104291353310.23685@cl320.eecs.utk.edu> <20110429185741.GB10217@elte.hu> <alpine.DEB.2.00.1104292200110.9459@cl320.eecs.utk.edu>
 <20110430081132.GA3705@liondog.tnic>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011, Borislav Petkov wrote:
> On Fri, Apr 29, 2011 at 10:17:04PM -0400, Vince Weaver wrote:

> > Well guess what, AMD family 15h changes all of that.
> 
> I don't see a big problem here, Robert has a patch that takes care of
> counter constraints. It probably needs a bit more work but we'll get
> where we need to be.

yes, but it's a bit of a change from the PMU of previous AMD chips,
going against Ingo's argument that the featureset of all modern CPUs is 
somehow converging.

> > And you're not going to like LWP. They got tired of waiting for a
> > workable kernel perf counter interface and moved it completely to
> > usersapce,
> 
> I don't know where you get your information but that's absolutely and
> completely not nearly even beginning to smell the truth.

I talked with someone fairly involved in the development with LWP who 
implied as much in an off-the-record discussion.  You have to admit back
5-6 years old when LWP was being planned it wasn't certain that kernel 
support for perf events was *ever* going to make it into Linux.
Though maybe AMD is more concerned about the even worse support in other 
OSes.  It's true you'd probably know better.

> Look at tip/x86/xsave, looks like LWP support will most likely be in
> 2.6.40.

Really?  Does Ingo know yet?  I get the impression he doesn't like 
perf-event features slipping in under the radar like that.

Vince

