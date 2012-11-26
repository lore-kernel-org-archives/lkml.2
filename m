Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2KZLVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:21:08 -0500
Received: from 8bytes.org ([85.214.48.195]:36956 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab2KZLVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:21:06 -0500
Date: Mon, 26 Nov 2012 12:20:58 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: shuah.khan@hp.com, a-jacquiot@ti.com, fenghua.yu@intel.com,
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
Message-ID: <20121126112058.GF25742@8bytes.org>
References: <1353706142.5270.93.camel@lorien2>
 <50B34B0F.3080204@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B34B0F.3080204@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Nov 26 12:21:03 2012
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50b3509f22972046314593
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 11:57:19AM +0100, Marek Szyprowski wrote:
> I've took all the patches to the next-dma-debug branch in my tree, I sorry
> that You have to wait so long for it. My branch is based on Joerg's
> dma-debug branch and I've included it for testing in linux-next branch.
> 
> Joerg: would You mind if I handle pushing the whole branch to v3.8
> via my kernel tree? Those changes should be kept close together to
> avoid build breaks for bisecting.

I'll apply the patches to my tree soon enough. But before that I'll wait
a little bit longer to give the arch maintainers the chance to add the
missing Acked-bys.


	Joerg


