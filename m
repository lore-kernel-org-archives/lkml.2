Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1LVPgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:36:50 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:56622
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752427Ab1LVPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:36:48 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1432N98dK4015Lzz1202hzzz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWM3D6-01-1UL-02
X-M-MSG: 
Date: Thu, 22 Dec 2011 16:36:10 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/4] perf, x86: Implement AMD IBS
Message-ID: <20111222153610.GC16765@erda.amd.com>
References: <1323968199-9326-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323968199-9326-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On 15.12.11 17:56:35, Robert Richter wrote:
> Changes for V4 (only patch #3 modified):
> 
>     * removed userland implementation from patch set, will post it as
>       separate patch series
>     * fix returned number of handled nmis in perf_ibs_handle_irq()

> Robert Richter (4):
>   perf, x86: Implement IBS event configuration
>   perf, x86: Implement IBS interrupt handler
>   perf, x86: Implement IBS pmu control ops
>   perf, x86: Implement 64 bit counter support for IBS
> 
>  arch/x86/include/asm/msr-index.h         |    5 +
>  arch/x86/include/asm/perf_event.h        |    2 +
>  arch/x86/kernel/cpu/perf_event_amd_ibs.c |  438 +++++++++++++++++++++++++++++-
>  3 files changed, 438 insertions(+), 7 deletions(-)

Assuming that there is agreement about the perf tool ibs
implementation, could you consider to apply the (kernel) patches? Not
sure what Arnaldo's plan is for the userland. It would be great to
have both ready for 3.3.

(Even if Peter is on vacation or so, except the fix in
perf_ibs_handle_irq() the kernel patches are unchanged and Peter
already agreed to apply them.)

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

