Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251Ab2FFX4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786Ab2FFX4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:56:38 -0400
Date: Wed, 6 Jun 2012 16:56:22 -0700
From: Chris Wright <chrisw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Don Dutile <ddutile@redhat.com>,
        iommu@lists.linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, chrisw@redhat.com,
        suresh.b.siddha@intel.com
Subject: Re: [PATCH 2/2] iommu: dmar -- reserve mmio space used by IOMMU
Message-ID: <20120606235622.GJ12686@x200.localdomain>
References: <1338845342-12464-1-git-send-email-ddutile@redhat.com>
 <1338845342-12464-3-git-send-email-ddutile@redhat.com>
 <1338849430.10884.288.camel@shinybook.infradead.org>
 <4FCD401D.9000304@redhat.com>
 <1338852196.26785.10.camel@shinybook.infradead.org>
 <20120606081600.GB5991@gmail.com>
 <1338971183.26785.33.camel@shinybook.infradead.org>
 <20120606082900.GF5991@gmail.com>
 <1338972329.26785.34.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338972329.26785.34.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> On Wed, 2012-06-06 at 10:29 +0200, Ingo Molnar wrote:
> > So for all practical purposes we get 99% of the warning power 
> > without going into chicken-and-egg problems like how do we 
> > determine that there's an IOMMU area there if there's no IOMMU 
> > aware code in the kernel, right? 
> 
> That's not a chicken-and-egg problem. It's hardly difficult to see the
> DMAR ACPI table and take a *basic* look at the DRHD entries. You don't
> even need to fully parse it.

I had the same impression as Ingo.  Patch is basically good as is (fixing
most of the problem), and could be augmented later to close the final gap
(when no IOMMU code).  While parsing the DMAR table is trivial, what are
you recommending to use to inform if the region is not properly reserved?

thanks,
-chris
