Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab0IBRzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:55:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0IBRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:55:39 -0400
X-Authority-Analysis: v=1.1 cv=+ajm3tfMPLNCEbkepGq+oOGV0QVCaQQ0JBMd0bjnRvg= c=1 sm=0 a=h6dlIqBDnR0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1_IIUYyouX6cPkEgYl4A:9 a=lp0sRgD8rKMbUHEvpm5cd9-ML0gA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: kernelshark plugins and ftrace array fields
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
In-Reply-To: <4C7FCB6C.9020304@redhat.com>
References: <4C7F9639.7000804@redhat.com>
	 <1283437521.2356.136.camel@gandalf.stny.rr.com> <4C7FB603.60609@redhat.com>
	 <1283442737.2356.212.camel@gandalf.stny.rr.com>
	 <4C7FCB6C.9020304@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Sep 2010 13:55:36 -0400
Message-ID: <1283450136.2356.337.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 19:06 +0300, Avi Kivity wrote:
> On 09/02/2010 06:52 PM, Steven Rostedt wrote:
> >
> >> plugin_kvm.c:
> >>
> >> kvm_emulate_insn_handler()
> >> {
> >>      fetch insn array and len field
> >>      feed into disassembler
> >>      trace_seq_printf() the disassembled instruction
> >> }
> > I don't have that tracepoint in any of my kernels. Is this new? I guess
> > if I see the TRACE_EVENT() I could emulate something and work with it.
> >
> 
> e46479f852ada, in 2.6.35-rc1.


Oops! sorry. All my boxes with KVM enabled were running 2.6.34 and I was
looking in the code under include/trace/events/kvm.h, forgetting that
these are defined in the arch/x86 tree.

Found it, thanks.

-- Steve



