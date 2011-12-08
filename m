Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab1LHAoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:44:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54236 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab1LHAoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:44:21 -0500
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <alpine.DEB.2.00.1112061604040.23414@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1111300011260.7107@cl320.eecs.utk.edu>
	<1322654092.2921.256.camel@twins>
	<CA+55aFwyYdN7HOkP0xanUOWd12zZhdqHCjnsWtdrs5LOxjg+Gg@mail.gmail.com>
	<alpine.DEB.2.00.1112010853430.31445@cl320.eecs.utk.edu>
	<CAMsRxfJmXXxDrofY3PDOLWRC7E-o6mANiTSJwYbyMTgOT_J0UA@mail.gmail.com>
	<alpine.DEB.2.00.1112061604040.23414@cl320.eecs.utk.edu>
Date: Wed, 7 Dec 2011 16:44:19 -0800
Message-ID: <CAMsRxfL3NVuz0dL-=iTJUsPMBt1frcfQ43fyc8pNoHEM9NXiOg@mail.gmail.com>
Subject: Re: perf_event self-monitoring overhead regression
From: stephane eranian <eranian@googlemail.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 1:07 PM, Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> On Thu, 1 Dec 2011, stephane eranian wrote:
>
>> I take it your test is all about self-monitoring, single event, single thread.
>> Did you try breaking down the cost using  TSC and rdtsc() to pinpoint where the
>> regression is coming from in the 3 perf_event syscalls you're using?
>
> I've started gathering results using rdtsc() and the results are even more
> puzzling.
>
Are those the results for surrounding the ioctl() with rdtsc()?

What do the axis actually represent?

> See:
>   http://web.eecs.utk.edu/~vweaver1/projects/perf-events/benchmarks/rdtsc_overhead/core2_raw_null_kernel_rdtsc.png
> for example.
>
> Those results are from a core2 machine, with the CPU scaling governor set
> to "performance", the test bound to CPU0, and the test run 1000 times.
>
> Part of the issue is that a few of those kernels are Debian unstable
> distro kernels and not hand-compiled stock kernels.  I'll rebuild a full
> set of kernels myself and see if I can reproduce the results.
>
> Vince
>
