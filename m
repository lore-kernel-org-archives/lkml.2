Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab0IKLsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 07:48:01 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:12158
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751427Ab0IKLsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 07:48:00 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2cK98dN4015Lzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8KZ9F-01-0YT-02
X-M-MSG: 
Date: Sat, 11 Sep 2010 13:44:04 +0200
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
Message-ID: <20100911114404.GE13563@erda.amd.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
 <1284118900.402.35.camel@laptop>
 <20100910132741.GB4879@redhat.com>
 <20100910144634.GA1060@elte.hu>
 <20100910155659.GD13563@erda.amd.com>
 <20100911094157.GA11521@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100911094157.GA11521@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.09.10 05:41:57, Ingo Molnar wrote:
> Robert, can you reproduce the problem? It triggers rather easily on both 
> Peter's and my AMD systems.

I was testing 88a377e and so far it didn't trigger on the system I
have available, will try other systems too. Can you send me your
config too?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

