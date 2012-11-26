Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab2KZQKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:10:04 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:24467 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2KZQKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:10:01 -0500
Message-ID: <1353946190.2917.5.camel@lorien2>
Subject: Re: [PATCH 0/9] dma_debug: add debug_dma_mapping_error support to
 architectures that support DMA_DEBUG_API
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>
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
Date: Mon, 26 Nov 2012 09:09:50 -0700
In-Reply-To: <20121126112217.GG25742@8bytes.org>
References: <1353706142.5270.93.camel@lorien2>
	 <20121126112217.GG25742@8bytes.org>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 12:22 +0100, Joerg Roedel wrote:
> Hi Shuah,
> 
> On Fri, Nov 23, 2012 at 02:29:02PM -0700, Shuah Khan wrote:
> > x86 - done in the first patch that added the feature.
> > 
> > ARM64: dma_debug: add debug_dma_mapping_error support
> > c6x: dma_debug: add debug_dma_mapping_error support
> > ia64: dma_debug: add debug_dma_mapping_error support
> > microblaze: dma-mapping: support debug_dma_mapping_error
> > mips: dma_debug: add debug_dma_mapping_error support
> > powerpc: dma_debug: add debug_dma_mapping_error support
> > sh: dma_debug: add debug_dma_mapping_error support
> > sparc: dma_debug: add debug_dma_mapping_error support
> > tile: dma_debug: add debug_dma_mapping_error support
> 
> Have you compile-tested the invididual archs you are changing here?
> 

Joerg,

Yes I compile tested all of them (except microblaze) on Nov 20th
linux_next git. The patch for microblaze is already in linux_next when I
tried to apply the patch to Nov 20th linux-next and figured that is
already covered and skipped that one.

-- Shuah

