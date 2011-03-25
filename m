Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1CYSmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:42:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1CYSl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:41:59 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=XYJHFtupD_QA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=P1zUWezRBjFxN6YTcGMA:9 a=ZY97AGKeJ9hrVKs1U5IA:7 a=gqsUaCeMo2gg6xv1g55CqRZ2SFYA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 25 Mar 2011 14:41:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>, torvalds@osdl.org,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: deadlock caused by printk
Message-ID: <20110325184158.GE9313@home.goodmis.org>
References: <AANLkTinCk35LSMLyO0nD+Z1ZmZskaCCN5c8kyxLcmXYx@mail.gmail.com>
 <1301055698.2250.198.camel@laptop>
 <1301055960.2250.202.camel@laptop>
 <AANLkTimw1+6DrYxxzkw7yh-t4W8rM55qcVd1nsQrAYT-@mail.gmail.com>
 <1301064627.2250.215.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301064627.2250.215.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 03:50:27PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-03-25 at 22:30 +0800, Ming Lei wrote:
> > 
> > But seems ftrace can't dump out the messages if system hangs,
> 
> True.

Well, matters how the system hangs. Add in a nmi watchdog or other
watchdogs which can also trigger the ftrace_dump_on_oops.

> 
> >  so could
> > we introduce a smart and simple "printk" which can be used in any
> > contexts? 
> 
> I think you could use early_printk() for that, it doesn't bother with
> all the syslog muck.
>

Heh, I should have read the thread before replying to the first post ;)

-- Steve

