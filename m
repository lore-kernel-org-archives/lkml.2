Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab0FPQsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:48:32 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59118 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0FPQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:48:31 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432N98dN936eM62a3Lzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L44973-02-AF5-02
X-M-MSG: 
Date: Wed, 16 Jun 2010 18:45:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/8] perf: register pmu implementations
Message-ID: <20100616164501.GS21799@erda.amd.com>
References: <20100616160027.590430763@chello.nl>
 <20100616160238.241599593@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100616160238.241599593@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.06.10 12:00:30, Peter Zijlstra wrote:
> Simple registration interface for struct pmu, this provides the
> infrastructure for removing all the weak functions.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/arm/kernel/perf_event.c             |   36 +
>  arch/powerpc/kernel/perf_event.c         |   41 +-
>  arch/powerpc/kernel/perf_event_fsl_emb.c |   31 -
>  arch/sh/kernel/perf_event.c              |   19
>  arch/sparc/kernel/perf_event.c           |   13
>  arch/x86/kernel/cpu/perf_event.c         |   45 +-
>  include/linux/perf_event.h               |   10
>  kernel/hw_breakpoint.c                   |   35 +
>  kernel/perf_event.c                      |  597 +++++++++++++++----------------
>  9 files changed, 432 insertions(+), 395 deletions(-)

Yes, this makes the code much more easier! Now it would be possible to
easy register multiple hw pmus.

Thanks Peter,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

