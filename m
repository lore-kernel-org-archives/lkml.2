Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab1ELJpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:45:22 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43556 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595Ab1ELJpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:45:20 -0400
Date: Thu, 12 May 2011 02:20:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110512092013.GJ2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DC9A5A4.1050308@kernel.org>
 <20110511045443.GS2258@linux.vnet.ibm.com>
 <BANLkTi=r707A9yy5-7+dw3Hozt=G1HBQ-Q@mail.gmail.com>
 <20110511201852.GC2258@linux.vnet.ibm.com>
 <4DCAF894.7030707@kernel.org>
 <4DCAFFD8.2080605@kernel.org>
 <4DCB157F.20202@kernel.org>
 <20110512060344.GB3191@elte.hu>
 <4DCB8BCD.1080607@kernel.org>
 <4DCB8F7A.90603@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCB8F7A.90603@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 12:42:50AM -0700, Yinghai Lu wrote:
> On 05/12/2011 12:27 AM, Yinghai Lu wrote:
> > On 05/11/2011 11:03 PM, Ingo Molnar wrote:
> >>
> >> * Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >>> e59fb3120becfb36b22ddb8bd27d065d3cdca499 is the first bad commit
> >>> commit e59fb3120becfb36b22ddb8bd27d065d3cdca499
> >>> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >>> Date:   Tue Sep 7 10:38:22 2010 -0700
> >>>
> >>>     rcu: Decrease memory-barrier usage based on semi-formal proof
> >>
> >> Find below an (untested!) attempt at reverting it for debugging purposes: could 
> >> you please try it, does your system now boot up fine?
> >>
> >> Thanks,
> >>
> >> 	Ingo
> >>
> > 
> > yes, reverted manually that commit fix the problem.
> 
> on system with 8 sockets westmere-ex
> 
> it seems other commits after that commit contribute some delay too.
> 
> [   32.240739] cpu_dev_init done
> [   73.587288] memory_dev_init done

I am testing a revert of e59fb3120becfb36b22ddb8bd27d065d3cdca499 and
will chase down the delay.

Could you please send along your .config file?

							Thanx, Paul
