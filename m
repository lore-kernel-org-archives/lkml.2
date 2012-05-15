Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab2EOIHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:07:14 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15634 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914Ab2EOIHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:07:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 15 May 2012 01:06:54 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Tue, 15 May 2012 10:06:49 +0200
Subject: Re: [PATCH 1/2] iommu/tegra: smmu: Simplify allocation at once
Thread-Topic: [PATCH 1/2] iommu/tegra: smmu: Simplify allocation at once
Thread-Index: Ac0yca8MFdChJRcIQ7qhegh25Ju2Kg==
Message-ID: <20120515.110649.2245510867001462236.hdoyu@nvidia.com>
References: <1337022975-23999-1-git-send-email-hdoyu@nvidia.com><4FB19677.4040702@wwwdotorg.org>
In-Reply-To: <4FB19677.4040702@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> wrote @ Tue, 15 May 2012 01:34:15 +0200:

> On 05/14/2012 01:16 PM, Hiroshi DOYU wrote:
> > To simplify the code, alloc necessary data at once.
> > 
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> > ---
> > This patch requires:
> > 
> >     [PATCH 1/2] iommu/tegra: smmu: Add device tree support for SMMU
> >         http://marc.info/?l=linux-tegra&m=133663641107327&w=2
> > 
> > Also the above patch requires:
> > 
> >     [PATCH 1/1] dt: Add general DMA window parser
> >         http://marc.info/?l=linux-tegra&m=133671302703840&w=2
> 
> I know I've been harping on about dependencies, but you typically only
> need to mention them if the dependencies are not already checked into
> the branch you expect this patch to be checked into.

There was a bit time gap. The former one is merged now. The latter
dt/DMA window patch isn't checked in.
