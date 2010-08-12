Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087Ab0HLNNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:13:36 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:41739
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760055Ab0HLNNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:13:35 -0400
X-SpamScore: 4
X-BigFish: VPS4(z3cfcs329eqz1432N98dN936eMzz1202hzzz32i2a8h43h64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0L71J8T-02-57M-02
X-M-MSG: 
Date: Thu, 12 Aug 2010 15:10:07 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100812131007.GW26154@erda.amd.com>
References: <20100804155002.GS3353@redhat.com>
 <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100811220058.GT26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100811220058.GT26154@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.08.10 00:00:58, Robert Richter wrote:
> I was debuging this a little more, see version 2 below.

I was testing the patch further, it properly filters perfctr
back-to-back nmis. I was able to reliable detect unknown nmis
triggered by the nmi button during high load perf sessions with
multiple counters, no false positives.

> 
> -Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

