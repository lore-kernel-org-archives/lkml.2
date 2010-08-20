Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab0HTIiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:38:19 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39722 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab0HTIiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:38:03 -0400
X-SpamScore: 7
X-BigFish: VPS7(z3cfcs329eqzbb2cK98dN148cMzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L7FZW9-01-PEC-02
X-M-MSG: 
Date: Fri, 20 Aug 2010 10:36:09 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100820083609.GX26154@erda.amd.com>
References: <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100817152225.GQ26154@erda.amd.com>
 <1282214753.1926.4669.camel@laptop>
 <20100819141240.GO4879@redhat.com>
 <1282228033.2605.204.camel@laptop>
 <20100820015017.GA4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100820015017.GA4879@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.08.10 21:50:17, Don Zickus wrote:
> I tested this patch and Robert's on an AMD box and Nehalem box.  Both
> worked as intended.  However I did notice that whenever the AMD box
> detected handled >1, it was shortly followed by an unknown_nmi that was
> properly eaten with Robert's logic.  Whereas on the Nehalem box I saw a
> lot of 'handled > 1' messages but very very few of them were followed by
> an unknown_nmi message (and those messages that did come were properly
> eaten).

Don, thanks for testing this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

