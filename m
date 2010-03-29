Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0C2Pln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:41:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0C2Pll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:41:41 -0400
X-Authority-Analysis: v=1.0 c=1 a=ANRBxz73AsgA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=3O1Q18jm6jdNaMSbWRgA:9 a=dbmokAEuO1b0lIwXajhpeLUPlZwA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCHv3 0/2] tracing: function graph output for
 preempt/irqs-off tracers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100329152154.GF1715@jolsa>
References: <1269606723-12439-1-git-send-email-jolsa@redhat.com>
	 <1269615239.19685.78.camel@gandalf.stny.rr.com>
	 <20100329111701.GC1715@jolsa>
	 <1269875347.19685.4492.camel@gandalf.stny.rr.com>
	 <20100329152154.GF1715@jolsa>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 29 Mar 2010 11:41:39 -0400
Message-ID: <1269877299.19685.4527.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 17:21 +0200, Jiri Olsa wrote:

> > Understand what I'm trying to ask?
> 
> ok, so what you mean is:
> - dont clear the max_tr and 
> - add function graph events.
> 
> So when the tracing_enabled and display-graph are disabled we will
> get events output rather than 'unknown event' output... right?

Right, although when the display-graph is disabled, we lose the /* */
but that's fine.

-- Steve


