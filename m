Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab0EGUEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:04:54 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:10414
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756943Ab0EGUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:04:52 -0400
X-SpamScore: -16
X-BigFish: VPS-16(z1857rz1432P98dN936eM4015L62a3Lzz1202hzz6ff19hz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L22FRP-02-4QK-02
X-M-MSG: 
Date: Fri, 7 May 2010 22:04:39 +0200
From: Robert Richter <robert.richter@amd.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "paulus@samba.org" <paulus@samba.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "fweisbec@gmail.com" <fweisbec@gmail.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "efault@gmx.de" <efault@gmx.de>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perf/core] perf probe: Support DW_OP_call_frame_cfa in
 debuginfo
Message-ID: <20100507200439.GZ6450@erda.amd.com>
References: <20100412171728.3790.98217.stgit@localhost6.localdomain6>
 <tip-a34a985499895a46a4dacff727d0fbc63cdc75e8@git.kernel.org>
 <20100507163321.GB15333@erda.amd.com>
 <4BE44AF4.3090303@redhat.com>
 <20100507183143.GB30926@ghostprotocols.net>
 <4BE46613.9090509@redhat.com>
 <4BE46E6D.6000502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BE46E6D.6000502@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.05.10 15:47:57, Masami Hiramatsu wrote:
> > Agreed. I'll check that what version can support current perf probe.
> 
> OK, I've found that the CFI support has been added at last June,
> and elfutils-0.142 is released in last July.

Yes, that's the problem, I am using elfutils-0.131-r2.

> So, I think we can check whether CFI is supported or not by checking
> the version of elfutils, which can be done by _ELFUTILS_PREREQ() macro
> defined in elfutils/version.h 

Looking forward to your fix.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

