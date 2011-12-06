Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab1LFLEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:04:39 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:32833 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147Ab1LFLEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:04:38 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVS43M-02-GJR-02
X-M-MSG: 
Date: Tue, 6 Dec 2011 12:04:30 +0100
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] perf tools: cleanups, fixes, updates
Message-ID: <20111206110430.GK15738@erda.amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.12.11 11:32:30, Robert Richter wrote:
> The patch set contains some cleanups, fixes and updates I found worth
> to implement during code review. Some patches can be applied
> independently.
> 
> Patches #1 and #2 are a repost.
> 
> Robert Richter (10):
>   perf script: Fix mem leaks and NULL pointer checks around strdup()s
>   perf script: Implement option for system-wide profiling
>   perf tools: Continue processing header on unknown features
>   perf tools: Fix out-of-bound access to struct perf_session
>   perf tool: Moving code in some files
>   perf report: Setup browser if stdout is a pipe
>   perf report: Accept fifos as input file
>   perf tool: Unify handling of features when writing feature section
>   perf tools: Improve macros for struct feature_ops
>   perf tools: Use for_each_set_bit() to iterate over feature flags

I just realized conflicts with latest tip/perf/core. This applies on
c23205c8488f11cb9ebe7a7b5851a1d8a0171011.

I can resent a rebased version but would like to wait for review
first.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

