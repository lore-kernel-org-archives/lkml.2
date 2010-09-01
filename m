Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab0IAJFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:05:12 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:27002
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751274Ab0IAJFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:05:08 -0400
X-SpamScore: 5
X-BigFish: VPS5(zzbb2cK1432N98dNzz1202hzz8275dhz32i2a8h5bep5bfs61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L82950-02-2YK-02
X-M-MSG: 
Date: Wed, 1 Sep 2010 10:38:08 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH 0/4] nmi perf fixes
Message-ID: <20100901083808.GH22783@erda.amd.com>
References: <1283309806-21913-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1283309806-21913-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.08.10 22:56:42, Don Zickus wrote:
> Fixes to allow unknown nmis to pass through the perf nmi handler instead
> of being swallowed.  Contains patches that are already in Ingo's tree.  Added
> here for completeness.  Based on ingo/tip
> 
> Tested on intel/amd
> 
> git pull git://fedorapeople.org/dzickus/
> 
> Don Zickus (2):
>   [x86] perf: rename nmi variable to avoid clash with entry point
>   [x86] perf: fix accidentally ack'ing a second event on intel perf
>     counter
> 
> Peter Zijlstra (1):
>   perf, x86: Fix handle_irq return values
> 
> Robert Richter (1):
>   perf, x86: Try to handle unknown nmis with an enabled PMU
> 
>  arch/x86/kernel/cpu/perf_event.c       |   59 +++++++++++++++++++++++++-------
>  arch/x86/kernel/cpu/perf_event_intel.c |   15 +++++---
>  arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
>  3 files changed, 56 insertions(+), 20 deletions(-)

Reviewed and tested. Looks good to me, thanks Don.

-Robert

> 
> -- 
> 1.7.2.2
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

