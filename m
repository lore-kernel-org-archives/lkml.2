Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab0FILse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:48:34 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55357 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab0FILsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:48:33 -0400
Date: Wed, 9 Jun 2010 17:17:53 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
Message-ID: <20100609114753.GB5878@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
 <1276012661.2046.120.camel@twins>
 <20100608173559.GE2800@linux.vnet.ibm.com>
 <1276024211.15884.107.camel@gandalf.stny.rr.com>
 <20100609050534.GA5878@linux.vnet.ibm.com>
 <1276065150.2046.1004.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1276065150.2046.1004.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-06-09 08:32:30]:

> On Wed, 2010-06-09 at 10:35 +0530, Srikar Dronamraju wrote:
> 
> > Peter, can you please point me to the fix for the floating point
> > exception patch?
> 
> Ingo just commited the fix, see tip commit f6ab91add6 (perf: Fix signed
> comparison in perf_adjust_period()).

Actually this fix was already checked-in but I still see the problem.

When ran gdb on the core, it showed me that it was dumping in
/usr/lib64/libnewt.so.0.52. in newtScaleSet function.
My newt lib was of version : newt-0.52.2-15

I am now able to workaround the problem by uninstalling newt-devel.

--
Thanks and Regards
Srikar
