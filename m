Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab2CWIrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:47:25 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34223 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2CWIrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:47:16 -0400
Date: Fri, 23 Mar 2012 09:47:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Vince Weaver <vince@deater.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: mmap_page capabilities and docs
Message-ID: <20120323084712.GE2886@gmail.com>
References: <1332433596.2487.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332433596.2487.33.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Usage:
> 
>   gcc -finstrument-functions -o my_prog main.c
>   LD_PRELOAD=profviz.so ./my_prog
> 
>   xdot prof.dot
> or
>   dot -Tsvg prof.svg prof.dot
> 
> The attached prof.svg it example output of:
> 
>   LD_PRELOAD=./profviz.so ./perf report

Nifty. Could we integrate this into 'perf profviz <myprog>' or 
so [feel free to use a better sub-tool name - 'perf selfprof' ?] 
and thus make it available to mere mortals as well?

'perf selfprof' could also warn about apps that were not built 
with -finstrument-functions.

Thanks,

	Ingo
