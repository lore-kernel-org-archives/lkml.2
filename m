Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab2KZLWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:22:25 -0500
Received: from 8bytes.org ([85.214.48.195]:37017 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab2KZLWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:22:24 -0500
Date: Mon, 26 Nov 2012 12:22:17 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.khan@hp.com>
Cc: a-jacquiot@ti.com, fenghua.yu@intel.com, catalin.marinas@arm.com,
        lethal@linux-sh.org, benh@kernel.crashing.org, ralf@linux-mips.org,
        tony.luck@intel.com, davem@davemloft.net, m.szyprowski@samsung.com,
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
Message-ID: <20121126112217.GG25742@8bytes.org>
References: <1353706142.5270.93.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353706142.5270.93.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Nov 26 12:22:22 2012
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50b350ee22976099613741
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

On Fri, Nov 23, 2012 at 02:29:02PM -0700, Shuah Khan wrote:
> x86 - done in the first patch that added the feature.
> 
> ARM64: dma_debug: add debug_dma_mapping_error support
> c6x: dma_debug: add debug_dma_mapping_error support
> ia64: dma_debug: add debug_dma_mapping_error support
> microblaze: dma-mapping: support debug_dma_mapping_error
> mips: dma_debug: add debug_dma_mapping_error support
> powerpc: dma_debug: add debug_dma_mapping_error support
> sh: dma_debug: add debug_dma_mapping_error support
> sparc: dma_debug: add debug_dma_mapping_error support
> tile: dma_debug: add debug_dma_mapping_error support

Have you compile-tested the invididual archs you are changing here?


	Joerg


