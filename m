Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab0HXR0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:26:00 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:25166
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932081Ab0HXRZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:25:58 -0400
X-SpamScore: 2
X-BigFish: VPS2(z3cfcs329eqzbb2cK1432N98dN4015Lzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L7O2ZJ-02-4I2-02
X-M-MSG: 
Date: Tue, 24 Aug 2010 19:15:05 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100824171504.GI26154@erda.amd.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100823085339.GA26713@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.08.10 04:53:39, Ingo Molnar wrote:
> Ok, to not hold up the perf/urgent flow i zapped these two commits for 
> the time being:
> 
>  4a31beb: perf, x86: Fix handle_irq return values
>  8e3e42b: perf, x86: Try to handle unknown nmis with an enabled PMU

Ingo, are those commits in some branch to fetch them for testing? I
did not find them in tip/master.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

