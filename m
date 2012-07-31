Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2GaSNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:13:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59467 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab2GaSNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:13:04 -0400
Message-ID: <50181FDC.4030200@zytor.com>
Date: Tue, 31 Jul 2012 11:11:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org> <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com> <1341598329.7709.57.camel@twins> <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com> <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com> <1341832997.3462.41.camel@twins> <20120709184145.GA7666@gmail.com> <1341906848.3462.92.camel@twins> <20120710082104.GA11187@gmail.com> <1341910360.3462.99.camel@twins> <20120710094803.GA14821@gmail.com>
In-Reply-To: <20120710094803.GA14821@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 02:48 AM, Ingo Molnar wrote:
>
> We could read out the current GDT [the SGDT instruction] instead
> of looking at gdt_page.
>
> Then we'd have to decode that descriptor, the limit. Decide
> whether the selector points to the GDT or LDT. All the fun x86
> legacies that we mostly forgot already after two decades of
> running the kernel in flat linear mode...
>

In 32-bit mode there are actually instructions that do that work for you.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

