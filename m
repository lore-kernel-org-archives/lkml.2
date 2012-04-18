Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2DRDne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 23:43:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2DRDnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 23:43:33 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_2gBi4Ny9w4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=rDVgynAY93M8l04WvN4A:9 a=WPZVj9nYBv1tIIgh3qYA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334720611.28106.25.camel@gandalf.stny.rr.com>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 17 Apr 2012 23:43:31 -0400
In-Reply-To: <20120418031557.GA29828@redhat.com>
References: <20120417172142.GA30237@redhat.com>
	 <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
	 <20120417203223.GA31699@redhat.com>
	 <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
	 <20120418022705.GA23877@home.goodmis.org>
	 <20120418031557.GA29828@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 23:15 -0400, Dave Jones wrote:

> That looks handy. Doesn't seem to work for me though on my test box.
> (config option is enabled.)
> 
> # echo 1 > /proc/sys/kernel/stack_tracer_enabled
> # cat /sys/kernel/debug/tracing/stack_trace
>         Depth    Size   Location    (-1 entries)
>         -----    ----   --------
> 
> That's all she wrote.

Hmm, was there any problems with the function tracer?
Messages in dmesg?

Just to make sure, what does

 /sys/kernel/debug/tracing/enabled_functions

have?

This would show what functions the stack tracer is using.

I just compiled the latest vanilla kernel and tried it out, and it
worked for me.

-- Steve


