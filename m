Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab2BBSE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:04:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2611 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab2BBSEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:04:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 02 Feb 2012 10:04:15 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 2 Feb 2012 10:04:12 -0800
Subject: RE: [PATCH v2 8/8] ARM: tegra: support for secondary cores on
 Tegra30
Thread-Topic: [PATCH v2 8/8] ARM: tegra: support for secondary cores on
 Tegra30
Thread-Index: AczgN015kuZlIgmRSziEBgxeEtpoQwBnUnqA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E124AA5@HQMAIL01.nvidia.com>
References: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
 <1328028051-24271-9-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1328028051-24271-9-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Tuesday, January 31, 2012 9:41 AM:
> Add support for bringing up secondary cores on Tegra30. On Tegra30 secondary
> CPU cores are powergated, so we need to turn on the domains before we can bring
> the CPU cores online. Bringing secondary cores online happens early during the
> sytem boot, so we call powergating initialization from platform early_init
> function.
> 
> Based on work by:
> 
> Scott Williams <scwilliams@nvidia.com>
> Colin Cross <ccross@android.com>
> Alex Frid <afrid@nvidia.com>
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

The series,

Tested-by: Stephen Warren <swarren@nvidia.com>

This time, since I now have the SD card working, I managed to test real
user-space processes running on all 4 cores.

Note, patch 3 shouldn't compile due to a typo in a .size directive. It
does for me, so I could test this! But, it didn't for Olof. Aside from
that (which perhaps Olof would fixup during patch application?),

Acked-by: Stephen Warren <swarren@nvidia.com>

I also have a query on patch 3 about enabling coresight, but that's more
for my education than something that'd block patch application.

-- 
nvpublic

