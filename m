Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab0FPRsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:48:18 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:33473
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756328Ab0FPRsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:48:16 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz98dN936eM62a3Lzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L44C46-01-RFZ-02
X-M-MSG: 
Date: Wed, 16 Jun 2010 19:48:04 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 6/8] perf: Per PMU disable
Message-ID: <20100616174804.GT21799@erda.amd.com>
References: <20100616160027.590430763@chello.nl>
 <20100616160238.529009255@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100616160238.529009255@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.06.10 12:00:33, Peter Zijlstra wrote:
> Changes perf_disable() into perf_disable_pmu().

I would rather use perf_pmu_disable() as this uses the perf_pmu_XXX
namespace.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

