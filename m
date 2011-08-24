Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1HXSWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:22:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:7635 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab1HXSW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:22:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="41814017"
Subject: Re: [patch 8/8] iommu: rename the DMAR and INTR_REMAP config options
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 24 Aug 2011 11:25:33 -0700
In-Reply-To: <20110824082848.GZ2079@amd.com>
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
	 <20110824001456.558630224@sbsiddha-desk.sc.intel.com>
	 <4E549E9B.7080004@kernel.org> <20110824082848.GZ2079@amd.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1314210333.16133.9.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 01:28 -0700, Roedel, Joerg wrote:
> On Wed, Aug 24, 2011 at 02:47:55AM -0400, Yinghai Lu wrote:
> > On 08/23/2011 05:05 PM, Suresh Siddha wrote:
> > > Change the CONFIG_DMAR to CONFIG_INTEL_IOMMU to be consistent with the other
> > > IOMMU options.
> > > 
> > > Rename the CONFIG_INTR_REMAP to CONFIG_IRQ_REMAP to match the irq
> > > subsystem name.
> > > 
> > > And define the CONFIG_DMAR_TABLE for the common ACPI DMAR routines
> > > shared by both CONFIG_INTEL_IOMMU and CONFIG_IRQ_REMAP.
> > 
> > is there something like IRQ_REMAP from AMD?
> 
> Yes there is. And I digged already through the existing VT-d code to see
> how it can be implemented side by side. Doesn't seem easy but should be
> doable. And it is on my list for the not too-distant future.

yeah I was not sure how different AMD's implementation is and so left it
as generic IRQ_REMAP. We can revisit this when the AMD's implementation
comes alive.

thanks,
suresh

