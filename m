Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0HQExl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:53:41 -0400
Received: from ozlabs.org ([203.10.76.45]:58002 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab0HQExj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:53:39 -0400
Date: Tue, 17 Aug 2010 13:46:34 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
        Will Deacon <will.deacon@arm.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 3/6] perf: Generalize some arch callchain code
Message-ID: <20100817034634.GB24726@drongo>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
 <1281991715-10367-4-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281991715-10367-4-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 10:48:32PM +0200, Frederic Weisbecker wrote:

> - Most archs use one callchain buffer per cpu, except x86 that needs
>   to deal with NMIs. Provide a default perf_callchain_buffer()
>   implementation that x86 overrides.
> 
> - Centralize all the kernel/user regs handling and invoke new arch
>   handlers from there: perf_callchain_user() / perf_callchain_kernel()
>   That avoid all the user_mode(), current->mm checks and so...
> 
> - Invert some parameters in perf_callchain_*() helpers: entry to the
>   left, regs to the right, following the traditional (src, dst).

I think you mean (dst, src), don't you?

Apart from that, the patch looks OK, so

Acked-by: Paul Mackerras <paulus@samba.org>

Paul.
