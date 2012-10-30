Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab2J3JBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:01:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36860 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2J3JBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:01:15 -0400
Date: Tue, 30 Oct 2012 10:01:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>, Arun Sharma <asharma@fb.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate hist
 periods
Message-ID: <20121030090110.GA10193@gmail.com>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
 <1351537727.4047.21.camel@twins>
 <508EF6C1.4000302@fb.com>
 <87ehkg78dx.fsf@sejong.aot.lge.com>
 <1351585065.4047.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351585065.4047.33.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2012-10-30 at 15:59 +0900, Namhyung Kim wrote:

> > Yes, the callchain part needs to be improved.  Peter's idea 
> > indeed looks good to me too.
> 
> FWIW, I think this is exactly what sysprof does, except that 
> tool isn't usable for other reasons.. You might want to look 
> at it though.

I always found the fundamental sysprof system-wide call graph 
profiling output/view superior - and so do many Xorg developers 
who are using SysProf that I talked to - so I'd strongly 
encourage to use that ordering and grouping for the default perf 
call-graph profiling output/view.

Thanks,

	Ingo
