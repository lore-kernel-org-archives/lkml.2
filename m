Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab0FJPNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:13:36 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52391 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0FJPNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:13:34 -0400
Date: Thu, 10 Jun 2010 20:42:43 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
Message-ID: <20100610151243.GP5878@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
 <1276012661.2046.120.camel@twins>
 <20100608173559.GE2800@linux.vnet.ibm.com>
 <1276024211.15884.107.camel@gandalf.stny.rr.com>
 <20100609050534.GA5878@linux.vnet.ibm.com>
 <1276181571.12038.21.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1276181571.12038.21.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > 
> > I tested this patch on the mainline(latest git), and perf record is able
> > to record events. However the other regressions still remain. I am
> > seeing these on mainline too.
> 
> But this means that the problem that I'm responsible for is fixed with
> this patch, correct?

Yes, 

> 
> If so, I'll package it up and add your "Tested-by:" tag. OK?

Okay.


--
Thanks and Regards
Srikar
