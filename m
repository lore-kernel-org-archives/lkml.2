Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab2AXU72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:59:28 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6271 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab2AXU70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:59:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 24 Jan 2012 12:57:22 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Laxman Dewangan <ldewangan@nvidia.com>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jan 2012 12:57:21 -0800
Subject: RE: [PATCH V1] arm: tegra: dma: not required to move requestor when
 stopping.
Thread-Topic: [PATCH V1] arm: tegra: dma: not required to move requestor
 when stopping.
Thread-Index: Aczab8bn3SNBNliHQyWy3sbXlw4ZvwAaqrjg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB81E5F@HQMAIL01.nvidia.com>
References: <1327392649-27605-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1327392649-27605-1-git-send-email-ldewangan@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laxman Dewangan wrote at Tuesday, January 24, 2012 1:11 AM:
> It is not require to move the requestor of dma to INVALID
> option before stopping dma.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

I know that Laxman has checked with the HW engineers, and they see no
reason to do this. I was originally worried about hung FIFOs preventing
an in-progress DMA from completely without the removed code, but according
to HW, that isn't a concern.

-- 
nvpublic

