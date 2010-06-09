Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab0FIFGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 01:06:09 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38114 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0FIFGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 01:06:07 -0400
Date: Wed, 9 Jun 2010 10:35:34 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
Message-ID: <20100609050534.GA5878@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
 <1276012661.2046.120.camel@twins>
 <20100608173559.GE2800@linux.vnet.ibm.com>
 <1276024211.15884.107.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1276024211.15884.107.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > I tested the patch and it fixed the regression where
> > perf record -e probe:do_fork -aR sleep 1 would fail. 
> > 
> 
> Thanks! Unfortunately the patch does two things, one is to fix this
> regression, the other is a clean up. Linus is currently only wanting
> fixes now and may not accept the clean up part of this patch. Can you
> test the patch below. It only addresses the regression.


I tested this patch on the mainline(latest git), and perf record is able
to record events. However the other regressions still remain. I am
seeing these on mainline too.

Peter, can you please point me to the fix for the floating point
exception patch? I am not sure if its because of the floating point
exception, but 'perf report' is showing blank output.

--
Thanks and Regards
Srikar

