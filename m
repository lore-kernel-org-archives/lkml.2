Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1EYSsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:48:51 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57090 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab1EYSst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:48:49 -0400
Date: Wed, 25 May 2011 11:47:38 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
Subject: Re: [PATCH 5/8] powerpc: override dma_get_required_mask by platform
 hook and ops
Message-ID: <20110525184738.GA10283@us.ibm.com>
References: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
 <1305152704-4864-6-git-send-email-nacc@us.ibm.com>
 <1305791036.7481.52.camel@pasglop>
 <20110519174625.GA3338@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519174625.GA3338@us.ibm.com>
X-Operating-System: Linux 2.6.38-8-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

On 19.05.2011 [10:46:25 -0700], Nishanth Aravamudan wrote:
> On 19.05.2011 [17:43:56 +1000], Benjamin Herrenschmidt wrote:
> > On Wed, 2011-05-11 at 15:25 -0700, Nishanth Aravamudan wrote:
> > > From: Milton Miller <miltonm@bga.com>
> > > 
> > > The hook dma_get_required_mask is supposed to return the mask required
> > > by the platform to operate efficently.  The generic version of
> > > dma_get_required_mask in driver/base/platform.c returns a mask based
> > > only on max_pfn.  However, this is likely too big for iommu systems
> > > and could be too small for platforms that require a dma offset or have
> > > a secondary window at a high offset.
> > 
> > The result of those 3 patches doesn't build on top of my current tree,
> > the generic dma_ops lacks the dma_get_required_mask hook. I'll have a
> > look again after the merge window.
> 
> Hrm, I think it's because for whatever reason [1] I forgot to cc you on 6/8?
> 
> https://lkml.org/lkml/2011/5/11/473

Were you able to find the patch I refer to above?

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
