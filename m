Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1KOPvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:51:41 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:9594 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab1KOPvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:51:40 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUPLDZ-01-7E0-02
X-M-MSG: 
Date: Tue, 15 Nov 2011 16:51:33 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chrisw@redhat.com" <chrisw@redhat.com>,
        "agraf@suse.de" <agraf@suse.de>, "dwg@au1.ibm.com" <dwg@au1.ibm.com>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        "B08248@freescale.com" <B08248@freescale.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: Re: [PATCH 0/4] iommu: iommu_ops group interface
Message-ID: <20111115155133.GE5627@amd.com>
References: <20111021195412.8438.9951.stgit@s20.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111021195412.8438.9951.stgit@s20.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 03:55:58PM -0400, Alex Williamson wrote:
> Alex Williamson (4):
>       iommu: Add option to group multi-function devices
>       amd-iommu: Implement iommu_device_group
>       intel-iommu: Implement iommu_device_group
>       iommu: Add iommu_device_group callback and iommu_group sysfs entry
> 
> 
>  Documentation/kernel-parameters.txt |    4 ++
>  arch/ia64/include/asm/iommu.h       |    2 +
>  arch/ia64/kernel/pci-dma.c          |    1 +
>  arch/x86/include/asm/iommu.h        |    1 +
>  arch/x86/kernel/pci-dma.c           |   11 ++++++
>  drivers/iommu/amd_iommu.c           |   21 ++++++++++++
>  drivers/iommu/intel-iommu.c         |   47 +++++++++++++++++++++++++++
>  drivers/iommu/iommu.c               |   61 +++++++++++++++++++++++++++++++++++
>  include/linux/iommu.h               |    7 ++++
>  9 files changed, 154 insertions(+), 1 deletions(-)

Applied with some changes to patch 1. I basically split up the
add_remove function into a add and a remove function. I think the code
is cleaner that way.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

