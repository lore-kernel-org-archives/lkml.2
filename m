Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab1I3O1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 10:27:17 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:13056
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620Ab1I3O1Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 10:27:16 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zzc89bh98dK4015Lzz1202hzzz32i668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LSCAS0-01-1A9-02
X-M-MSG: 
Date: Fri, 30 Sep 2011 16:25:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andi Kleen <ak@linux.intel.com>, Corey Minyard <minyard@acm.org>,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [V6][PATCH 3/6] x86, nmi: wire up NMI handlers to new routines
Message-ID: <20110930142549.GA21506@erda.amd.com>
References: <1316805435-14832-1-git-send-email-dzickus@redhat.com>
 <1316805435-14832-4-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1316805435-14832-4-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.09.11 15:17:12, Don Zickus wrote:
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 594d425..90ffec5 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1377,68 +1377,14 @@ struct pmu_nmi_state {
>  static DEFINE_PER_CPU(struct pmu_nmi_state, pmu_nmi);

Don, please remove this too and also struct pmu_nmi_state:

 arch/x86/kernel/cpu/perf_event.c:1066: warning: ‘pmu_nmi’ defined but not used

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

