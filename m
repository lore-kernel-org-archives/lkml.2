Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab2KWV3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 16:29:17 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:39783 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2KWV3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 16:29:15 -0500
Message-ID: <1353706142.5270.93.camel@lorien2>
Subject: [PATCH 0/9] dma_debug: add debug_dma_mapping_error support to
 architectures that support DMA_DEBUG_API
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joro@8bytes.org>, a-jacquiot@ti.com, fenghua.yu@intel.com,
        catalin.marinas@arm.com, lethal@linux-sh.org, benh@kernel.crashing.org,
        ralf@linux-mips.org, tony.luck@intel.com, davem@davemloft.net,
        m.szyprowski@samsung.com, msalter@redhat.com, monstr@monstr.eu,
        Ming Lei <ming.lei@canonical.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        linux-c6x-dev@linux-c6x.org, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, shuahkhan@gmail.com
Date: Fri, 23 Nov 2012 14:29:02 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An earlier patch added dma mapping error debug feature to dma_debug
infrastructure. References:

https://lkml.org/lkml/2012/10/8/296
https://lkml.org/lkml/2012/11/3/219

The following series of patches adds the call to debug_dma_mapping_error() to
architecture specific dma_mapping_error() interfaces on the following
architectures that support CONFIG_DMA_API_DEBUG.

arm64
c6x
ia64
microblaze
mips
powerpc
sh
sparc
tile

arm - Change is already in Marek's dma-mapping tree[1] 
https://patchwork.kernel.org/patch/1625601/

microblaze - Change is already in linux-next. Including it for completeness
linux-next commit f229605441030bcd315c21d97b25889d63ed0130

x86 - done in the first patch that added the feature.

ARM64: dma_debug: add debug_dma_mapping_error support
c6x: dma_debug: add debug_dma_mapping_error support
ia64: dma_debug: add debug_dma_mapping_error support
microblaze: dma-mapping: support debug_dma_mapping_error
mips: dma_debug: add debug_dma_mapping_error support
powerpc: dma_debug: add debug_dma_mapping_error support
sh: dma_debug: add debug_dma_mapping_error support
sparc: dma_debug: add debug_dma_mapping_error support
tile: dma_debug: add debug_dma_mapping_error support

Thanks,
-- Shuah

