Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0ILJxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 05:53:13 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:31992 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab0ILJxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 05:53:11 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L8MOQQ-01-F55-02
X-M-MSG: 
Date: Sun, 12 Sep 2010 11:52:03 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
Message-ID: <20100912095202.GF13563@erda.amd.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
 <1284118900.402.35.camel@laptop>
 <20100910132741.GB4879@redhat.com>
 <20100910144634.GA1060@elte.hu>
 <20100910155659.GD13563@erda.amd.com>
 <20100911094157.GA11521@elte.hu>
 <20100911114404.GE13563@erda.amd.com>
 <20100911124537.GA22850@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100911124537.GA22850@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.09.10 08:45:37, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > On 11.09.10 05:41:57, Ingo Molnar wrote:
> > > Robert, can you reproduce the problem? It triggers rather easily on both 
> > > Peter's and my AMD systems.
> > 
> > I was testing 88a377e and so far it didn't trigger on the system I 
> > have available, will try other systems too. Can you send me your 
> > config too?
> 
> Sure, attached.

No, your config did not trigger it either. We will extend testing to
more systems, but I cannot start with it before tomorrow.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

