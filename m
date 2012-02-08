Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2BHVkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:40:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:58007 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2BHVkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:40:04 -0500
Message-ID: <1328737168.2903.35.camel@pasglop>
Subject: Re: [PATCH 1/3] Device isolation group infrastructure (v3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: David Gibson <david@gibson.dropbear.id.au>, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, aik@ozlabs.ru, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 09 Feb 2012 08:39:28 +1100
In-Reply-To: <20120208152748.GD22598@amd.com>
References: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
	 <1328071614-8320-2-git-send-email-david@gibson.dropbear.id.au>
	 <20120208152748.GD22598@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 16:27 +0100, Joerg Roedel wrote:
> Again, device grouping is done by the IOMMU drivers, so this all
> belongs
> into the generic iommu-code rather than the driver core.

Except that there isn't really a "generic iommu code"... discovery,
initialization & matching of iommu vs. devices etc... that's all
implemented in the arch specific iommu code.

Cheers,
Ben.
  
> I think it makes sense to introduce a device->iommu pointer which
> depends on CONFIG_IOMMU_API and put the group information into it.
> This also has the benefit that we can consolidate all the
> device->arch.iommu pointers into device->iommu as well.
> 
> 

