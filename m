Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0ETXGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 19:06:44 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:55611
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754743Ab0ETXGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 19:06:42 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz98dN936eM62a3Lzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L2QQUS-01-KHD-02
X-M-MSG: 
Date: Fri, 21 May 2010 01:06:30 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
Message-ID: <20100520230629.GX21799@erda.amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
 <4BF46000.20203@linux.vnet.ibm.com>
 <20100520065143.GA14480@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100520065143.GA14480@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.05.10 02:51:43, Ingo Molnar wrote:

> Whether IBS fits that category is an open question - 
> ideally it should have similar high level usage as the 
> PEBS/LBR bits on Intel CPUs. (at least as far as tooling 
> goes)

Ingo,

high level usage is from the perspective of perf tools. IBS delivers
high detailed diagnostic data that is also processed by userland tools
other than perf. If we would introduce another interface layer it
becomes much harder for such tools to use the pmu via this layer. The
raw data is of much more interest here for users. If we think of
perf_event as a subsystem controlling the pmu in a single instance, it
should provide access to set and get raw pmu registers. I see this as
a necessary feature.

Nevertheless I agree that key features should be exposed also with a
high level interface and if possible in an abstracted non-model
specific way.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

