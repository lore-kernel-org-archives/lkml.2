Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203Ab2EDQyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:54:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47870 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2EDQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:54:01 -0400
Message-ID: <4FA409A6.3020700@wwwdotorg.org>
Date: Fri, 04 May 2012 10:53:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "ccross@android.com" <ccross@android.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/1] ARM: tegra: Add Tegra Memory Controller(MC) driver
References: <1336063897-12083-1-git-send-email-hdoyu@nvidia.com><4FA2D0C4.4020608@wwwdotorg.org> <20120504.160035.1828735037330038337.hdoyu@nvidia.com>
In-Reply-To: <20120504.160035.1828735037330038337.hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 07:00 AM, Hiroshi Doyu wrote:
...
> What about the following AHB patches? AHB patches are independent of
> MC/GART/SMMU DT issue basically. If you think that they are ready to
> merge, I'll post the update version, I fixed some of your latest
> comments.
> 
>  [PATCH 1/3] ARM: tegra: Add Tegra AHB driver
>  [PATCH 2/3] ARM: tegra: Add SMMU enabler in AHB
>  [PATCH 3/3] ARM: dt: tegra: Add device tree support for AHB

Yes, I think they be reposted and go in now.

> I'll hold off on the following until we get some direction for
> MC/GART/SMMU. They are related to how dt info is passed via MC.
> 
>  [PATCH 1/3] ARM: tegra: Add Tegra Memory Controller(MC) driver
>  [PATCH 2/3] ARM: dt: tegra: Add device tree support for Memory Controller(MC)
>  [PATCH 3/3] iommu/tegra: smmu: Refrain from accessing to AHB
