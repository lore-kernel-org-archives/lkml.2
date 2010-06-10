Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab0FJUlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 16:41:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36424 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab0FJUlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 16:41:22 -0400
X-Authority-Analysis: v=1.1 cv=0V+YgKZNf9d26/fBPLboOTCGR+CNKxq3cOm2BYeWuVM= c=1 sm=0 a=eX2VPhT_8KEA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=FJZqyOkMMHY2Lybp9EMA:9 a=wJtubqPqLk-A7b36r5dWnn0a4twA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][RFC] tracing: Use class->reg() for all registering of
 events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <1276202200.2077.820.camel@twins>
References: <1276011215.15884.96.camel@gandalf.stny.rr.com>
	 <1276012661.2046.120.camel@twins>
	 <20100608173559.GE2800@linux.vnet.ibm.com>
	 <1276024211.15884.107.camel@gandalf.stny.rr.com>
	 <1276195271.28329.2.camel@gandalf.stny.rr.com>
	 <1276202200.2077.820.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Jun 2010 16:41:20 -0400
Message-ID: <1276202480.28329.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 22:36 +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-10 at 14:41 -0400, Steven Rostedt wrote:
> > Can I get an Acked-by from you on this patch? I know you acked the clean
> > up version. But this is a minimal fix for .35. We'll add the clean up
> > version to .36.
> 
> Sure,
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks!

-- Steve


