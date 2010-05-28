Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab0E1VqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:46:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab0E1VqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:46:01 -0400
X-Authority-Analysis: v=1.1 cv=Pm0qIGCwx3bIEOZlSg1a56K3RSwKBTW9sPEb+DFvEKk= c=1 sm=0 a=PjWTFMnUE30A:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=0phde27D1wbc2mqcr6QA:9 a=j9wD7HLNL3BZrZJ4WxcA:7 a=NcW4SKmcHiKdh-1AehGFDzee6vsA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Perf trace event parse errors for KVM events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
In-Reply-To: <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>
	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 28 May 2010 17:45:57 -0400
Message-ID: <1275083157.22648.593.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 17:42 +0100, Stefan Hajnoczi wrote:
> I get parse errors when using Steven Rostedt's trace-cmd tool, too.
> 
> Any ideas what is going on here?  I can provide more info (e.g. trace
> files) if necessary.

Does trace-cmd fail on the same tracepoints? Have you checkout the
latest code?.

I do know it fails on some of the KVM tracerpoints since the formatting
they use is obnoxious.

Could you show the "print-fmt" of the failing events?

Thanks,

-- Steve


