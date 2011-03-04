Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab1CDWmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:42:35 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56958 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab1CDWma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:42:30 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6275"; a="78123072"
Message-ID: <4D716AD5.1070403@codeaurora.org>
Date: Fri, 04 Mar 2011 14:42:29 -0800
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, will.deacon@arm.com,
        jamie.iles@picochip.com, jean.pihet@newoldbits.com,
        robert.richter@amd.com, dwalker@fifo99.com, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ARM: Add Scorpion/ScorpionMP support to perf and
 Oprofile
References: <1299276551-11978-1-git-send-email-sheetals@codeaurora.org>
In-Reply-To: <1299276551-11978-1-git-send-email-sheetals@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 02:09 PM, Sheetal Sahasrabudhe wrote:
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
>  arch/arm/kernel/perf_event_qc.c            |  677 ++++++++++++++++++++++++++++
>  arch/arm/mach-msm/Makefile                 |    2 +
>  arch/arm/mach-msm/include/mach/irqs-7x30.h |    2 +-
>  arch/arm/mach-msm/include/mach/irqs-8960.h |    2 +-
>  arch/arm/mach-msm/include/mach/irqs-8x50.h |    2 +-
>  arch/arm/mach-msm/include/mach/irqs-8x60.h |    2 +-
>  arch/arm/mach-msm/pmu.c                    |   36 ++
>  arch/arm/oprofile/common.c                 |    4 +
>  10 files changed, 736 insertions(+), 4 deletions(-)
>  create mode 100644 arch/arm/kernel/perf_event_qc.c
>  create mode 100644 arch/arm/mach-msm/pmu.c
> 

Some minor comments from a quick review:
- you're using multi-line commenting style for single line comments
- see Documentation/CodingStyle, Chapter 8, for preferred multi-line
commenting style
- 'mv perf_event_qc.c perf_event_msm.c'?

- Bryan

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
