Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab0HPW43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 18:56:29 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:25234
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756103Ab0HPW42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 18:56:28 -0400
X-SpamScore: 12
X-BigFish: VPS12(z3cfcs329eqzbb2cK98dNzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L79P0D-02-82Y-02
X-M-MSG: 
Date: Tue, 17 Aug 2010 00:55:25 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100816225525.GO26154@erda.amd.com>
References: <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100816190659.GI5805@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100816190659.GI5805@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.08.10 15:06:59, Cyrill Gorcunov wrote:
> I suspect Peter was supposed to be in To: field ;)

It was the attempt to answer 2 mails with one. :)

> Robert, I think we still may miss unknown irq, consider the case when
> unknown nmi is latched while you handle nmi from perf and what is
> more interesting several counters may be overflowed. So you set
> delta small enough and second (unknown nmi) will be in range and
> treated as being perf back-to-back, or I miss something from patch?

Yes, that's true, but before you have to enable your Infinite
Improbability Drive.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

