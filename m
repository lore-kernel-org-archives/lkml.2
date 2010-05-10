Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0EJFWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:22:40 -0400
Received: from ozlabs.org ([203.10.76.45]:46660 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab0EJFWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:22:39 -0400
Date: Mon, 10 May 2010 15:20:56 +1000
From: Paul Mackerras <paulus@samba.org>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu, efault@gmx.de,
       avi@redhat.com, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move
 perf on top of TP
Message-ID: <20100510052056.GB20793@drongo>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
 <1272994165.1642.203.camel@laptop>
 <4BE0FB68.7080403@kernel.org>
 <1273050400.1642.229.camel@laptop>
 <4BE13B33.3030709@kernel.org>
 <1273053073.1642.235.camel@laptop>
 <4BE1406C.2000400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE1406C.2000400@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 11:54:52AM +0200, Tejun Heo wrote:

> On 05/05/2010 11:51 AM, Peter Zijlstra wrote:
> >> I was wondering the other way around - ie. the possibility to make
> >> perf optional and maybe even as a module which depends on TPs, which
> >> would be nicer than the current situation and make the code less
> >> cluttered too. 
> > 
> > I really really hate making perf rely on tracepoints.
> 
> Hmmm.... may I ask why?  Unifying hooking mechanism seems like a good
> idea to me and it's not like it's gonna add any runtime overhead
> although it does complicate init/exit but well that's something you
> have to pay if you wanna do things dynamically and sans the ifdef
> stuff it's like a couple hundred lines of isolated code.

Don't forget where perf_events started out - as a way to count and
record hardware events.  So perf_events is very useful even in a
kernel that has no tracing infrastructure configured in at all. 

Paul.
