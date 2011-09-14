Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1INPkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:40:31 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56407 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755292Ab1INPka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:40:30 -0400
X-SpamScore: -11
X-BigFish: VPS-11(z1039oz1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LRIRIC-02-ODG-02
X-M-MSG: 
Date: Wed, 14 Sep 2011 17:39:47 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] iommu/omap: migrate to the generic fault report
 mechanism
Message-ID: <20110914153947.GX11701@amd.com>
References: <1315941989-17199-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1315941989-17199-1-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 03:26:29PM -0400, Ohad Ben-Cohen wrote:
> Start using the generic fault report mechanism, as provided by
> the IOMMU core, and remove its now-redundant omap_iommu_set_isr API.
> 
> Currently we're only interested in letting upper layers know about the
> fault, so in case the faulting device is a remote processor, they could
> restart it.
> 
> Dynamic PTE/TLB loading is not supported.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  arch/arm/plat-omap/include/plat/iommu.h |    3 +--
>  drivers/iommu/omap-iommu.c              |   31 +++----------------------------
>  2 files changed, 4 insertions(+), 30 deletions(-)

Applied both to new branch iommu/fault-reporting and merged into my next
branch. Thanks Ohad.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

