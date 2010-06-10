Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab0FJOw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:52:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56432 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759313Ab0FJOwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:52:54 -0400
X-Authority-Analysis: v=1.1 cv=rR912iD8TqKBQWPhXASLR67rt2rT9ApkpBWj5XB9Duc= c=1 sm=0 a=eX2VPhT_8KEA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=HctP3hEG2wxs9diSdjAA:9 a=KZQCPycqfN8o5v7qVVvcM6THn-cA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <20100609050534.GA5878@linux.vnet.ibm.com>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
	 <1276012661.2046.120.camel@twins>
	 <20100608173559.GE2800@linux.vnet.ibm.com>
	 <1276024211.15884.107.camel@gandalf.stny.rr.com>
	 <20100609050534.GA5878@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Jun 2010 10:52:51 -0400
Message-ID: <1276181571.12038.21.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 10:35 +0530, Srikar Dronamraju wrote:
> > 
> > > I tested the patch and it fixed the regression where
> > > perf record -e probe:do_fork -aR sleep 1 would fail. 
> > > 
> > 
> > Thanks! Unfortunately the patch does two things, one is to fix this
> > regression, the other is a clean up. Linus is currently only wanting
> > fixes now and may not accept the clean up part of this patch. Can you
> > test the patch below. It only addresses the regression.
> 
> 
> I tested this patch on the mainline(latest git), and perf record is able
> to record events. However the other regressions still remain. I am
> seeing these on mainline too.

But this means that the problem that I'm responsible for is fixed with
this patch, correct?

If so, I'll package it up and add your "Tested-by:" tag. OK?

Thanks,

-- Steve


