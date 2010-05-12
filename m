Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab0ELOE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:04:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48422 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab0ELOEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:04:55 -0400
Date: Wed, 12 May 2010 19:34:33 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 0/10] Uprobes v3
Message-ID: <20100512140433.GD13606@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6> <1273611585.1810.132.camel@laptop> <20100512102518.GA30767@linux.vnet.ibm.com> <1273666385.1626.96.camel@laptop> <20100512132708.GC13606@in.ibm.com> <1273671560.1626.114.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273671560.1626.114.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 03:39:20PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-12 at 18:57 +0530, Ananth N Mavinakayanahalli wrote:
> > Now, as long as we have the housekeeping code to handle the
> > possibility of a thread hitting the said breakpoint when its being
> > removed, is it safe to assume atomicity for replacing one byte of
> > possibly a longer instruction? 
> 
> Dunno I'm not a hardware guy, but the issue is so simple to side-step
> I'm not sure why you're arguing for relying on these special semantics.

Yes we know what to do, but I am just trying to get clarity if its
possible at all, since Mathieu was pretty sure that the hoops aren't
necessary...

Ananth
