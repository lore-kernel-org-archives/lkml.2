Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab2DXQhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:37:42 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:43234
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755662Ab2DXQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:37:40 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz1432N98dK4015Izz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2ZSUM-01-ZFT-02
X-M-MSG: 
Date: Tue, 24 Apr 2012 18:37:31 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] perf: Kernel updates
Message-ID: <20120424163731.GG9747@erda.amd.com>
References: <1333643084-26776-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1333643084-26776-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.04.12 18:24:40, Robert Richter wrote:
> Enclosed some changes made while working with the code. Mostly trivial
> but worth to add.
> 
> -Robert
> 
> 
> Robert Richter (4):
>   perf: Trivial cleanup of duplicate code
>   perf, x86: Fix cmpxchg() usage in amd_put_event_constraints()
>   perf: use static variant of perf_event_overflow in core.c
>   perf: Remove PERF_COUNTERS config option

Peter,

what's the status of this?

Thanks,

-Robert

> 
>  arch/arm/configs/bcmring_defconfig        |    2 +-
>  arch/powerpc/configs/chroma_defconfig     |    2 +-
>  arch/powerpc/configs/gamecube_defconfig   |    2 +-
>  arch/powerpc/configs/wii_defconfig        |    2 +-
>  arch/sh/configs/sh7785lcr_32bit_defconfig |    2 +-
>  arch/sparc/configs/sparc64_defconfig      |    2 +-
>  arch/x86/kernel/cpu/perf_event.c          |    3 ---
>  arch/x86/kernel/cpu/perf_event_amd.c      |    4 +---
>  init/Kconfig                              |   14 +-------------
>  kernel/events/core.c                      |    2 +-
>  10 files changed, 9 insertions(+), 26 deletions(-)
> 
> -- 
> 1.7.8.4
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

