Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab1KJPWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:22:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:50014 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1KJPWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:22:38 -0500
Message-ID: <1320938548.22195.10.camel@i7.infradead.org>
Subject: Re: [PATCH 2/4] intel-iommu: Implement iommu_device_group
From: David Woodhouse <dwmw2@infradead.org>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chrisw@redhat.com" <chrisw@redhat.com>,
        "agraf@suse.de" <agraf@suse.de>, "dwg@au1.ibm.com" <dwg@au1.ibm.com>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        "B08248@freescale.com" <B08248@freescale.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Date: Thu, 10 Nov 2011 15:22:28 +0000
In-Reply-To: <20111108172348.GF5182@amd.com>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <20111021195611.8438.84499.stgit@s20.home> <20111108172348.GF5182@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 18:23 +0100, Roedel, Joerg wrote:
> On Fri, Oct 21, 2011 at 03:56:11PM -0400, Alex Williamson wrote:
> > We generally have BDF granularity for devices, so we just need
> > to make sure devices aren't hidden behind PCIe-to-PCI bridges.
> > We can then make up a group number that's simply the concatenated
> > seg|bus|dev|fn so we don't have to track them (not that users
> > should depend on that).
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> David, does this look good to you? Can you send an Acked-by if its okay?

Looks good to me in principle, although I'd like to see it tested on one
of those HP laptops with the dodgy Ricoh multi-function devices.

Acked-By: David Woodhouse <David.Woodhouse@intel.com>

-- 
dwmw2

