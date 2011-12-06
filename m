Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1LFQX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:23:57 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:4008
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508Ab1LFQXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:23:55 -0500
X-SpamScore: -17
X-BigFish: VPS-17(zz98dK4015Lzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVSIVM-02-23E-02
X-M-MSG: 
Date: Tue, 6 Dec 2011 17:23:46 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: KyongHo Cho <pullip.cho@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, <linux-kernel@vger.kernel.org>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        <iommu@lists.linux-foundation.org>,
        <linux-samsung-soc@vger.kernel.org>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 0/2] iommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
Message-ID: <20111206162346.GP25178@amd.com>
References: <1321609650-1329-1-git-send-email-pullip.cho@samsung.com>
 <20111205154715.GE25178@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111205154715.GE25178@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 04:47:15PM +0100, Joerg Roedel wrote:

> Okay, I merged it into arm/exynos, but it is not pushed yet. Actually
> there were conflicts while merging, which I resolved. What I failed
> to find is a config for Exynos that actually builds for upstream Linux.
> Probably I havn't tried hard enough to find one... Can you provide a
> kernel config that I can use for my testing and that builds a current
> 3.2-rc4 kernel for Exynos?

Okay, since there are new objections and since I can't even reliably
build test the driver I unmerged it again.
Please fix the outstanding issues and rebase it against a recent upstream
kernel so that the result can be compiled to a kernel-image.


Thanks,

	Joerg


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

