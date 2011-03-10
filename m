Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab1CJSdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:33:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1CJSdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:33:08 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=T5FwMGfWojYA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=aqw89YG9nVSNO93D6AwA:9 a=TgAPsImhdatgfQAYkIDzQ_apzeUA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 10 Mar 2011 13:33:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110310183305.GD12521@home.goodmis.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110307204346.19557183C29@magilla.sf.frob.com>
 <20110309102855.GC27010@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309102855.GC27010@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 11:28:55AM +0100, Tejun Heo wrote:
> 
> If someone is looking for completely transparent light weight
> monitoring, there is a much better fitting mechanism for that and it
> works frigging well and provides much better insight into what's going
> on with the system.
> 
> Use tracing for tracing.
> 

Hmm, what tracing utility exactly? If I want to trace a running task,
that I have the debug info on it where I would have the ability to
insert probes, which utility would you recommend?

strace and gdb use ptrace

ftrace focuses on the kernel.

I don't think perf has a good way to trace userspace yet.

I haven't taken a good look at lttng, but I think it has some sort of
library that is attached to the process. Is there a better way than
attching a library to said task.

systemtap may have ways too, but I think it depends on utrace which has
pretty much been nak'd in the kernel.

-- Steve

