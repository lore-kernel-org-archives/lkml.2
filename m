Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1KWXkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 18:40:17 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39644 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1KWXkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 18:40:16 -0500
Date: Wed, 23 Nov 2011 23:39:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@nvidia.com>
Cc: Jon Medhurst <tixy@yxit.co.uk>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sumit Bhattacharya <sumitb@nvidia.com>
Subject: Re: [PATCH] arm: dma:  Drop GFP_COMP for DMA memory allocations
Message-ID: <20111123233957.GM9581@n2100.arm.linux.org.uk>
References: <1320442539-7753-1-git-send-email-swarren@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF174080512F@HQMAIL01.nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF174F08C785@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174F08C785@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:10:03AM -0800, Stephen Warren wrote:
> Stephen Warren wrote at Wednesday, November 09, 2011 11:04 AM:
> > Stephen Warren wrote at Friday, November 04, 2011 3:36 PM:
> > > dma_alloc_coherent wants to split pages after allocation in order to
> > > reduce the memory footprint. This does not work well with GFP_COMP
> > > pages, so drop this flag before allocation.
> > >
> > > This patch is ported from arch/avr32
> > > (commit 3611553ef985ef7c5863c8a94641738addd04cff).
> > >
> > > Signed-off-by: Sumit Bhattacharya <sumitb@nvidia.com>
> > > Tested-by: Varun Colbert <vcolbert@nvidia.com>
> > > [swarren: s/HUGETLB_PAGE/HUGETLBFS/ in comment, minor comment cleanup]
> > > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > 
> > Russell, does this look good to go in the patch system now?
> 
> ping?

I think so.
