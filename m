Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab0IMOh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:37:26 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18736 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0IMOhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:37:25 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8OWM0-01-043-02
X-M-MSG: 
Date: Mon, 13 Sep 2010 16:37:13 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: Don Zickus <dzickus@redhat.com>, "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
Message-ID: <20100913143713.GK13563@erda.amd.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
 <1284118900.402.35.camel@laptop>
 <20100910132741.GB4879@redhat.com>
 <20100910144634.GA1060@elte.hu>
 <20100910155659.GD13563@erda.amd.com>
 <20100911094157.GA11521@elte.hu>
 <20100911114404.GE13563@erda.amd.com>
 <20100911124537.GA22850@elte.hu>
 <20100912095202.GF13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100912095202.GF13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.09.10 11:52:02, Robert Richter wrote:
> On 11.09.10 08:45:37, Ingo Molnar wrote:
> > 
> > * Robert Richter <robert.richter@amd.com> wrote:
> > 
> > > On 11.09.10 05:41:57, Ingo Molnar wrote:
> > > > Robert, can you reproduce the problem? It triggers rather easily on both 
> > > > Peter's and my AMD systems.
> > > 
> > > I was testing 88a377e and so far it didn't trigger on the system I 
> > > have available, will try other systems too. Can you send me your 
> > > config too?
> > 
> > Sure, attached.
> 
> No, your config did not trigger it either. We will extend testing to
> more systems, but I cannot start with it before tomorrow.

Ingo, Peter,

I finally found a system here, will start debugging

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

