Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab1D2O5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:57:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1D2O5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:57:12 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=z492W0U-jkMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=o1BfdMrSRHiYsAPEspkA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC 0/3] x86_64,tracing: multiplexing function tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1304088194-6214-1-git-send-email-jolsa@redhat.com>
References: <1304088194-6214-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Apr 2011 10:57:10 -0400
Message-ID: <1304089030.18763.257.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 16:43 +0200, Jiri Olsa wrote:
> hi, me again ;)
> 
> from last RFC email it turned out it'd be good to have support
> for more than 1 currently running function tracers. With
> the possibility to specify separate filter for each of them.

Jiri, I thought I told you to wait, as I'm basically doing the same
thing. Except that I'm gutting the heck out of ftrace.c.

I've been working the last several days rewriting this code.

> 
> I thought about one way how to do that and put it to the
> code for considering. It seems to work properly, though
> I was fighting with set_ftrace_filter for a while.. and
> it is still not ideal ;)

Soon, set_ftrace_filter will only affect the function tracer and not any
other user of function tracing.

I'm almost done. I was hoping to release something today, but it will
probably have to wait till next week.

-- Steve


