Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1LUQwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:52:45 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:10354
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874Ab1LUQwm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:52:42 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zzc89bh1432N98dKzz1202hzz8275bhz2dh668h839h93fh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LWKC7N-01-E0U-02
X-M-MSG: 
Date: Wed, 21 Dec 2011 17:52:33 +0100
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/4] perf tool: Parse general/raw events from sysfs
Message-ID: <20111221165233.GL16765@erda.amd.com>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
 <1323969824-9711-2-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1323969824-9711-2-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.12.11 18:23:41, Robert Richter wrote:
> From: Lin Ming <ming.m.lin@intel.com>
> 
> PMU can export general events to sysfs, for example,
> 
> /sys/bus/event_source/devices/uncore/events
> └── cycle
> 
> Then specify the event as <pmu>:<event>,
> 
> $ sudo perf stat -a -C 0 -e uncore:cycle
> ^C
>  Performance counter stats for 'CPU 0':
> 
>         56,547,314 uncore:cycle
> 
> Raw event can be specified as <pmu>:rXXXX
> 
> $ sudo perf stat -a -C 0 -e uncore:r0101
> ^C
>  Performance counter stats for 'CPU 0':
> 
>              8,504 uncore:r0101
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Forgot this:

Signed-off-by: Robert Richter <robert.richter@amd.com>

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

