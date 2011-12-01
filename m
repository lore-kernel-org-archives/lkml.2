Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1LAAil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:38:41 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53978 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1LAAii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:38:38 -0500
Date: Thu, 1 Dec 2011 11:11:53 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        chrisw@redhat.com, agraf@suse.de, scottwood@freescale.com,
        B08248@freescale.com, benh@kernel.crashing.org
Subject: Re: [PATCH 4/4] iommu: Add option to group multi-function devices
Message-ID: <20111201001153.GC5427@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>, joerg.roedel@amd.com,
	dwmw2@infradead.org, iommu@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
	scottwood@freescale.com, B08248@freescale.com,
	benh@kernel.crashing.org
References: <20111021195412.8438.9951.stgit@s20.home>
 <20111021195624.8438.75945.stgit@s20.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021195624.8438.75945.stgit@s20.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11113014-5490-0000-0000-0000003BB194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 01:56:24PM -0600, Alex Williamson wrote:
> The option iommu=group_mf indicates the that the iommu driver should
> expose all functions of a multi-function PCI device as the same
> iommu_device_group.  This is useful for disallowing individual functions
> being exposed as independent devices to userspace as there are often
> hidden dependencies.  Virtual functions are not affected by this option.

This seems ok as a testing/debugging hack.  But in general, surely,
whether to group the functions should be a device quirk.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

