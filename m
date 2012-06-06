Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2FFI3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:29:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57710 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2FFI3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:29:06 -0400
Date: Wed, 6 Jun 2012 10:29:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>, iommu@lists.linux-foundation.org,
        mingo@elte.hu, linux-kernel@vger.kernel.org, chrisw@redhat.com,
        suresh.b.siddha@intel.com
Subject: Re: [PATCH 2/2] iommu: dmar -- reserve mmio space used by IOMMU
Message-ID: <20120606082900.GF5991@gmail.com>
References: <1338845342-12464-1-git-send-email-ddutile@redhat.com>
 <1338845342-12464-3-git-send-email-ddutile@redhat.com>
 <1338849430.10884.288.camel@shinybook.infradead.org>
 <4FCD401D.9000304@redhat.com>
 <1338852196.26785.10.camel@shinybook.infradead.org>
 <20120606081600.GB5991@gmail.com>
 <1338971183.26785.33.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338971183.26785.33.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2012-06-06 at 10:16 +0200, Ingo Molnar wrote:
>
> > So basically the patch-set is fine as-is, we just want a 
> > sufficiently nasty sounding warning message about the BIOS 
> > bug,
> 
> No. The other change that's required is that the warning and 
> the workaround need to trigger even when IOMMU support isn't 
> built into the kernel. This BIOS bug can bite you even when 
> you aren't *using* the IOMMU.

Right, but that's the status quo and most of the time (distro 
kernels) the driver is available, right?

So for all practical purposes we get 99% of the warning power 
without going into chicken-and-egg problems like how do we 
determine that there's an IOMMU area there if there's no IOMMU 
aware code in the kernel, right?

Thanks,

	Ingo
