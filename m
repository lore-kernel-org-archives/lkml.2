Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2FACaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 22:30:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12874 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413Ab2FACae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 22:30:34 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=6I2XFdsDAPIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=5kq3ZftqeXhTmIkYi7QA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338517831.13348.455.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/5] x86: Allow nesting of the debug stack IDT setting
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 22:30:31 -0400
In-Reply-To: <1338492300.13348.384.camel@gandalf.stny.rr.com>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020441.500105258@goodmis.org> <4FC7BF59.3070906@zytor.com>
	 <1338492300.13348.384.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 15:25 -0400, Steven Rostedt wrote:
> On Thu, 2012-05-31 at 11:58 -0700, H. Peter Anvin wrote:
> 
> > What you have here is a nesting counter, which is good, but I have
> > some objections to the implementation.
> > 
> > The name "debug_idt_zero" doesn't convey a counter in any way, shape
> > or form; perhaps debug_stack_users or something like that.
> 
> Well, it is 'debug_idt_SET_zero' which is what it is doing, regardless
> of counter (see below). But perhaps we should change it to:
> 
> debug_idt_get()
> debug_idt_put()

Bah, silly me, I misunderstood you. You were talking about the counter
itself, not the function names.

OK, will fix.

Thanks,

-- Steve


