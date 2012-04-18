Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab2DREJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:09:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2DREJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:09:25 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_2gBi4Ny9w4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=3vHdtuhL4dbHvftFQAkA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334722164.28106.31.camel@gandalf.stny.rr.com>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2012 00:09:24 -0400
In-Reply-To: <20120418040632.GB31465@redhat.com>
References: <20120417172142.GA30237@redhat.com>
	 <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
	 <20120417203223.GA31699@redhat.com>
	 <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
	 <20120418022705.GA23877@home.goodmis.org>
	 <20120418031557.GA29828@redhat.com>
	 <1334720611.28106.25.camel@gandalf.stny.rr.com>
	 <20120418035004.GA31465@redhat.com>
	 <1334721441.28106.28.camel@gandalf.stny.rr.com>
	 <20120418040632.GB31465@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 00:06 -0400, Dave Jones wrote:

> That just prints out..
> 
> # tracer: function
> #
> # entries-in-buffer/entries-written: 0/0   #P:4
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
> 
>  > I'm also assuming you have CONFIG_STACKTRACE and
>  > CONFIG_STACKTRACE_SUPPORT enabled. They should be selected, but configs
>  > can always get screwed up.
> 
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_STACKTRACE=y
> 

OK, function tracing is broken on your box. Could you send me your full
config and I'll take a look at it tomorrow. Bed time for me now ;-)

-- Steve


