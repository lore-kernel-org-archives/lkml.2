Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1IWMXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:23:54 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:37901
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440Ab1IWMXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:23:53 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz146fK1432N1a09M98dK4015Lzz1202hzzz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LRZ6FK-01-2BO-02
X-M-MSG: 
Date: Fri, 23 Sep 2011 14:20:14 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20110923122014.GP6063@erda.amd.com>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
 <1316778523.9084.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316778523.9084.17.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.09.11 07:48:43, Peter Zijlstra wrote:

> There was also the thing about putting perf_event_set_period() and
> perf_event_try_update() in a common library and converting all pmu
> implementations to use them.
> 
> As well as the for_each_set_bit_continue() thing which you've got
> queued.

Yeah, I will post separate patches for this.

> Anyway, I read through the stuff and it looks about right, so I'll wait
> for Don to post his NMI infrastructure bits once more (he had some
> pending changes) and then I'll queue this on top.

Many thanks.

> The only thing I'm not quite sure on is the userspace bits, but those
> are in the future work section as well, but possibly Ingo has a strong
> opinion here, sadly he doesn't have email atm :/

With Lin's patch 'perf: Remove perf_event_attr::type check' we already
can sample with perf record.

I think we could extend perf report to parse also ibs samples. The
only thing we need for it should be the pmu name/type mapping in the
perf.data header and the pmu type in the sample. See my comment on
Stephane's patch '[PATCH] perf: make perf.data more self-descriptive
(v5)'.

Thanks,

-Robert


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

