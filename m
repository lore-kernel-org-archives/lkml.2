Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab1ESHoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 03:44:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:50973 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab1ESHop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 03:44:45 -0400
Subject: Re: [PATCH 5/8] powerpc: override dma_get_required_mask by
 platform hook and ops
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Milton Miller <miltonm@bga.com>, Paul Mackerras <paulus@samba.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Anton Blanchard <anton@samba.org>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>,
        Will Schmidt <will_schmidt@vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        cbe-oss-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org
In-Reply-To: <1305152704-4864-6-git-send-email-nacc@us.ibm.com>
References: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
	 <1305152704-4864-6-git-send-email-nacc@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 17:43:56 +1000
Message-ID: <1305791036.7481.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 15:25 -0700, Nishanth Aravamudan wrote:
> From: Milton Miller <miltonm@bga.com>
> 
> The hook dma_get_required_mask is supposed to return the mask required
> by the platform to operate efficently.  The generic version of
> dma_get_required_mask in driver/base/platform.c returns a mask based
> only on max_pfn.  However, this is likely too big for iommu systems
> and could be too small for platforms that require a dma offset or have
> a secondary window at a high offset.

The result of those 3 patches doesn't build on top of my current tree,
the generic dma_ops lacks the dma_get_required_mask hook. I'll have a
look again after the merge window.

Cheers,
Ben.


