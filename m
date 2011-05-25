Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab1EYID5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:03:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:54751 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab1EYIDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:03:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,266,1304319600"; 
   d="scan'208";a="7200957"
Date: Wed, 25 May 2011 16:16:05 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Song, Youquan" <youquan.song@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: manual merge of the dwmw2-iommu tree with Linus'
	tree
Message-ID: <20110525201605.GA30842@linux-youquan.bj.intel.com>
References: <20110525130004.150c054f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525130004.150c054f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 01:00:04PM +1000, Stephen Rothwell wrote:
> Hi David,
> 
> Today's linux-next merge of the dwmw2-iommu tree got a conflict in
> arch/x86/kernel/apic/apic.c between commit 31dce14a3269 ("x86, ioapic:
> Use ioapic_saved_data while enabling intr-remapping") from Linus' tree and
> commit 6a87c5ec6463 ("intel-iommu: enable x2apic opt out") from the
> dwmw2-iommu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

The fix looks good to me.

Thanks
-Youquan

