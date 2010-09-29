Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0I2QdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:33:10 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:50182
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971Ab0I2QdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:33:08 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9IOMK-01-D94-02
X-M-MSG: 
Date: Wed, 29 Sep 2010 18:32:46 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Stephane Eranian <eranian@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20100929163246.GO13563@erda.amd.com>
References: <20100929125301.GG13563@erda.amd.com>
 <20100929125453.GH13563@erda.amd.com>
 <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
 <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com>
 <20100929150140.GK13563@erda.amd.com>
 <20100929151253.GL13563@erda.amd.com>
 <20100929152745.GC9440@lenovo>
 <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
 <20100929154528.GD9440@lenovo>
 <20100929155102.GE9440@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100929155102.GE9440@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.10 11:51:02, Cyrill Gorcunov wrote:
> On Wed, Sep 29, 2010 at 07:45:28PM +0400, Cyrill Gorcunov wrote:
> ... 
> > Btw, since x86 architectural and p4 are using same tests for
> > running I presume better to have some helper rather then
> > open coded pile?

I rather tend to merge the x86 and p4 handler, the code is almost the
same.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

