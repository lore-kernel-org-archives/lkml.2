Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab2EPQ6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:58:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2EPQ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:58:33 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ylC6d8igtuBafk5u--MA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337187503.6724.50.camel@gandalf.stny.rr.com>
Subject: Re: Perf record format portability
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Date: Wed, 16 May 2012 12:58:23 -0400
In-Reply-To: <20120516145927.GC7864@infradead.org>
References: <4FB275EB.5050904@linaro.org>
	 <20120515155146.GB7864@infradead.org> <4FB38677.8070601@linaro.org>
	 <20120516145927.GC7864@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 11:59 -0300, Arnaldo Carvalho de Melo wrote:

> Steve,
> 
> 	Was the kernel trace events infrastructure designed with that in
> mind? I.e. cross analysis? I must be missing something here, still
> ENOCOFFEE :-\

Yes, the libparsevents library was design for this from day one. That's
why trace-cmd data file can be run on an ARM and read on x86, or PPC, or
whatever. I did all my development testing against 32bit, 64bit and big
and little endian. This was the case from the beginning.

-- Steve

> 
> 	When doing cross arch event analisys I tested:
> 
>         PERF_TYPE_HARDWARE                      = 0,
>         PERF_TYPE_SOFTWARE                      = 1,
>         PERF_TYPE_HW_CACHE                      = 3,
> 
> Not:
> 
>         PERF_TYPE_TRACEPOINT                    = 2,
>         PERF_TYPE_RAW                           = 4,
>         PERF_TYPE_BREAKPOINT                    = 5,
> 
> - Arnaldo


