Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1HPVFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:05:15 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:6195
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab1HPVFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:05:13 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432N98dK4015Lzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQ1H8F-02-7R0-02
X-M-MSG: 
Date: Tue, 16 Aug 2011 23:05:03 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20110816210503.GZ11702@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311959236.5890.420.camel@twins>
 <20110801052128.GW4590@erda.amd.com>
 <1312284595.1147.96.camel@twins>
 <20110812194344.GJ11702@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110812194344.GJ11702@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.08.11 21:43:44, Robert Richter wrote:
> On 02.08.11 07:29:55, Peter Zijlstra wrote:
> > Right, so comparing Fam10 to Fam12,
> > 
> > + IbsOpCtl.19:58
> > + IbsOpData.38
> > - IbsOpData2.4:5
> 
> Yeah, good catch. This is due to the different northbridge
> implementations. I will ask the hw guys how to handle this.

Both bits are meant to be architectural and defined the same on all
cpus. On families 12h and 14h they always return 0. The documentation
will be updated accordingly.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

