Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1CPOG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:06:29 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:44067
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab1CPOGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:06:22 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI5LU9-01-P0C-02
X-M-MSG: 
Date: Wed, 16 Mar 2011 15:06:10 +0100
From: Robert Richter <robert.richter@amd.com>
To: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "jamie.iles@picochip.com" <jamie.iles@picochip.com>,
        "jean.pihet@newoldbits.com" <jean.pihet@newoldbits.com>,
        "dwalker@fifo99.com" <dwalker@fifo99.com>,
        "bryanh@codeaurora.org" <bryanh@codeaurora.org>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ARM: Add Scorpion/ScorpionMP support to perf
 and Oprofile
Message-ID: <20110316140610.GN31407@erda.amd.com>
References: <1299534404-25346-1-git-send-email-sheetals@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1299534404-25346-1-git-send-email-sheetals@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.03.11 16:46:44, Sheetal Sahasrabudhe wrote:
> This patchset contains the following features:
> It adds support for Qualcomm Scorpion and ScorpionMP processors to perfevents
> and Oprofile.
> It adds PMU support for Scorpion and ScorpionMP.
> It also updates PMU IRQ identifiers for various Scorpion and ScorpionMP targets.
> 
> Sheetal Sahasrabudhe (3):
>   msm: Add support for Scorpion and ScorpionMP PMU
>   [ARM] perfevents: Add support for Scorpion performance monitors
>   [ARM] Oprofile: Add Qualcomm Scorpion and ScorpionMP CPU type
> 
>  arch/arm/include/asm/perf_event.h          |    2 +
>  arch/arm/kernel/perf_event.c               |   11 +
>  arch/arm/kernel/perf_event_msm.c           |  665 ++++++++++++++++++++++++++++
>  arch/arm/mach-msm/Makefile                 |    2 +
>  arch/arm/mach-msm/include/mach/irqs-7x30.h |    2 +-
>  arch/arm/mach-msm/include/mach/irqs-8960.h |    2 +-
>  arch/arm/mach-msm/include/mach/irqs-8x50.h |    2 +-
>  arch/arm/mach-msm/include/mach/irqs-8x60.h |    2 +-
>  arch/arm/mach-msm/pmu.c                    |   35 ++
>  arch/arm/oprofile/common.c                 |    4 +

Oprofile changes ...

Acked-by: Robert Richter <robert.richter@amd.com>

>  10 files changed, 723 insertions(+), 4 deletions(-)
>  create mode 100644 arch/arm/kernel/perf_event_msm.c
>  create mode 100644 arch/arm/mach-msm/pmu.c
> 
> -- 
> 1.7.4.1
> 
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

