Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2KZK50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:57:26 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10998 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab2KZK5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:57:24 -0500
Message-id: <50B34B0F.3080204@samsung.com>
Date: Mon, 26 Nov 2012 11:57:19 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: shuah.khan@hp.com
Cc: Joerg Roedel <joro@8bytes.org>, a-jacquiot@ti.com, fenghua.yu@intel.com,
        catalin.marinas@arm.com, lethal@linux-sh.org, benh@kernel.crashing.org,
        ralf@linux-mips.org, tony.luck@intel.com, davem@davemloft.net,
        msalter@redhat.com, monstr@monstr.eu,
        Ming Lei <ming.lei@canonical.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        shuahkhan@gmail.com
Subject: Re: [PATCH 0/9] dma_debug: add debug_dma_mapping_error support to
 architectures that support DMA_DEBUG_API
References: <1353706142.5270.93.camel@lorien2>
In-reply-to: <1353706142.5270.93.camel@lorien2>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/23/2012 10:29 PM, Shuah Khan wrote:
> An earlier patch added dma mapping error debug feature to dma_debug
> infrastructure. References:
>
> https://lkml.org/lkml/2012/10/8/296
> https://lkml.org/lkml/2012/11/3/219
>
> The following series of patches adds the call to debug_dma_mapping_error() to
> architecture specific dma_mapping_error() interfaces on the following
> architectures that support CONFIG_DMA_API_DEBUG.

I've took all the patches to the next-dma-debug branch in my tree, I sorry
that You have to wait so long for it. My branch is based on Joerg's
dma-debug branch and I've included it for testing in linux-next branch.

Joerg: would You mind if I handle pushing the whole branch to v3.8
via my kernel tree? Those changes should be kept close together to
avoid build breaks for bisecting.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


