Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161Ab0EYWBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:01:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab0EYWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:01:32 -0400
X-Authority-Analysis: v=1.1 cv=WC2cwRI/KXdLNEmE8ivg2cmI8vFt6dWmaZdvaJ93QHU= c=1 sm=0 a=mI6YO6ZdSLUA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=LDAwBmX4x4Svb3WsdWYA:9 a=PJrfSe69N3LPhGRzMg-V0ZzI2eAA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Tracing configuration review
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100525201736.GB5370@nowhere>
References: <1274815906.9757.83.camel@cndougla-ubuntu>
	 <1274816768.22648.220.camel@gandalf.stny.rr.com>
	 <20100525201736.GB5370@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 18:01:06 -0400
Message-ID: <1274824866.1876.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 22:17 +0200, Frederic Weisbecker wrote:
> On Tue, May 25, 2010 at 03:46:08PM -0400, Steven Rostedt wrote:
> > On Tue, 2010-05-25 at 15:31 -0400, Chase Douglas wrote:
> > > # CONFIG_SCHED_TRACER is not set (headed for deprecation?)
> > 
> > Although it is headed for deprecation, I think it still gets set by
> > other tracers, since it has the code to initiate the comm reader.
> 
> 
> 
> Doesn't actually CONTEXT_SWITCH_TRACER has the code for the
> comm things?
> 

Ah, I was confused. But then the SCHED_TRACER is the wakeup tracer, and
that is heading for deprecation??

-- Steve


