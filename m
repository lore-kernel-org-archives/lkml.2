Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab2EKSFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:05:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51909 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972Ab2EKSFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:05:02 -0400
Message-ID: <4FAD54C9.6040904@wwwdotorg.org>
Date: Fri, 11 May 2012 12:04:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iommu/tegra: smmu: Add device tree support for SMMU
References: <1336636221-31575-1-git-send-email-hdoyu@nvidia.com> <1336636221-31575-2-git-send-email-hdoyu@nvidia.com> <4FAC2041.7030405@wwwdotorg.org> <20120511094625.GA11750@amd.com>
In-Reply-To: <20120511094625.GA11750@amd.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 03:46 AM, Joerg Roedel wrote:
> On Thu, May 10, 2012 at 02:08:33PM -0600, Stephen Warren wrote:
>> On 05/10/2012 01:50 AM, Hiroshi DOYU wrote:
>>> The necessary info is expected to pass from DT.
>>>
>>> For more precise resource reservation, there shouldn't be any
>>> overlapping of register range between SMMU and MC. SMMU register
>>> offset needs to be calculated correctly, based on its register bank.
>>>
>>> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
>>
>> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
>>
>> I expect patch 1 will go through the IOMMU tree, and I'll take patch 2
>> through the Tegra tree.
> 
> Any reason for splitting it up? The patches touch mostly drivers/iommu.
> So to avoid conflicts its probably the best to apply them together.

Patch 1 is the driver that touches drivers/iommu and related
documentation, whereas patch 2 touches the device tree file in
arch/arm/boot/dts. Either of the patches would get conflicts if they
were merged into the "other" tree.
