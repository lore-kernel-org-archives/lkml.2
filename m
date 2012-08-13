Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2HMPdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:33:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51888 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2HMPdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:33:11 -0400
Message-ID: <1344871976.31459.35.camel@twins>
Subject: Re: [BUG] perf: sharing of cpuctx between core and ibs PMU causes
 problems
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>, mingo@elte.hu
Date: Mon, 13 Aug 2012 17:32:56 +0200
In-Reply-To: <CABPqkBREO7GE8qYqVoeyfFyC+gdn+TOf8f9sp_Yu0_O1Eds55A@mail.gmail.com>
References: <CABPqkBRWLcP_9WOL_VvucnY7A2AcpzuvsUt4_ZUgYMREo-65dA@mail.gmail.com>
	 <50235ED0.5010107@intel.com>
	 <CABPqkBT-pvmhyOHfMXs7dXsJXpEVmaSST1xFFHzCu4CDBf7baw@mail.gmail.com>
	 <1344535707.20277.20.camel@twins>
	 <CABPqkBRzyrmL_yiKnYWU4qaSZXbD=JJVnm5py4PUcgAYvT=hcA@mail.gmail.com>
	 <1344853682.31459.20.camel@twins>
	 <CABPqkBREO7GE8qYqVoeyfFyC+gdn+TOf8f9sp_Yu0_O1Eds55A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 14:53 +0200, Stephane Eranian wrote:
> 
> Your proposal solves the problem, though it is not that pretty because
> you're exposing
> IBS stuff in sched.h aside for the 2 new iterations. But I don't see
> another way around
> this at this point. 

Yeah, I don't particularly like it either.. but I'm having a similar
problem of not seeing anything better.

I was going to see if I could make the two IBS PMUs share something, but
that's going to be pain whichever way you turn it.
