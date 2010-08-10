Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab0HJTFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:05:55 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57938 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab0HJTFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:05:51 -0400
X-SpamScore: 10
X-BigFish: VPS10(z3cfcs329eqz98dN936eMzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L6YADI-01-44A-02
X-M-MSG: 
Date: Tue, 10 Aug 2010 21:05:41 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100810190541.GN26154@erda.amd.com>
References: <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100809200245.GF6056@lenovo>
 <20100810074200.GE26154@erda.amd.com>
 <20100810161627.GB6893@lenovo>
 <20100810164124.GK26154@erda.amd.com>
 <20100810172451.GD6893@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100810172451.GD6893@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.08.10 13:24:51, Cyrill Gorcunov wrote:

> It gets masked on NMI arrival, at least for some models (Core Duo, P4,
> P6 M and I suspect more theh that, that was the reason oprofile has
> it, also there is a note in SDM V3a page 643).

Yes, that's right, I never noticed that. Maybe it is better to
implement the apic write it in model specific code then.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

