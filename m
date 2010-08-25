Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0HYLIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 07:08:12 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37575 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0HYLII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 07:08:08 -0400
X-SpamScore: 6
X-BigFish: VPS6(z3cfcs329eqzbb2cK1432N98dNzz1202hzzz32i2a8h43h63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0L7PFZT-02-6U7-02
X-M-MSG: 
Date: Wed, 25 Aug 2010 13:02:18 +0200
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
Message-ID: <20100825110218.GG3198@erda.amd.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100825094819.GB3198@erda.amd.com>
 <20100825104130.GA27891@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100825104130.GA27891@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.08.10 06:41:30, Ingo Molnar wrote:

> > > > > Uhhuh. NMI received for unknown reason 00 on CPU 9.
> > > > > Do you have a strange power saving mode enabled?
> > > > > Dazed and confused, but trying to continue
> 
> Before the two patches i did not get these messages at all, on any of 
> the systems.

Yes, because all were eaten by NOTIFY_STOP, and that's why we also
lose NMIs from other sources, like the nmi button. The patches try to
fix this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

