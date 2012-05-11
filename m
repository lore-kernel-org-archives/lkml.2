Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab2EKJrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:47:11 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:28878 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932175Ab2EKJrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:47:07 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dI9371I1432N98dKzz1202hzz15d4R8275bh8275dhz2dh668h839h944hd25he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3UR58-02-302-02
X-M-MSG: 
Date: Fri, 11 May 2012 11:46:25 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Hiroshi DOYU <hdoyu@nvidia.com>, <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] iommu/tegra: smmu: Add device tree support for SMMU
Message-ID: <20120511094625.GA11750@amd.com>
References: <1336636221-31575-1-git-send-email-hdoyu@nvidia.com>
 <1336636221-31575-2-git-send-email-hdoyu@nvidia.com>
 <4FAC2041.7030405@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FAC2041.7030405@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 02:08:33PM -0600, Stephen Warren wrote:
> On 05/10/2012 01:50 AM, Hiroshi DOYU wrote:
> > The necessary info is expected to pass from DT.
> > 
> > For more precise resource reservation, there shouldn't be any
> > overlapping of register range between SMMU and MC. SMMU register
> > offset needs to be calculated correctly, based on its register bank.
> > 
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> I expect patch 1 will go through the IOMMU tree, and I'll take patch 2
> through the Tegra tree.

Any reason for splitting it up? The patches touch mostly drivers/iommu.
So to avoid conflicts its probably the best to apply them together.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

