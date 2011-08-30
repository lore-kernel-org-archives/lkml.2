Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1H3T0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:26:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9256 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab1H3T0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:26:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 30 Aug 2011 12:26:18 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Chris Ball <cjb@laptop.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 30 Aug 2011 12:26:16 -0700
Subject: RE: [PATCH 1/3] arm/dt: Tegra: Update SDHCI nodes to match bindings
Thread-Topic: [PATCH 1/3] arm/dt: Tegra: Update SDHCI nodes to match bindings
Thread-Index: AcxnSeXPFU21nrB3SSeLra7/kVn21QAAGoRQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B3279E01@HQMAIL01.nvidia.com>
References: <1314731837-6985-1-git-send-email-swarren@nvidia.com>
 <m2hb4yso44.fsf@bob.laptop.org>
In-Reply-To: <m2hb4yso44.fsf@bob.laptop.org>
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

Chris Ball wrote at Tuesday, August 30, 2011 1:20 PM:
> Hi Stephen,
> 
> On Tue, Aug 30 2011, Stephen Warren wrote:
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > Acked-by: Olof Johansson <olof@lixom.net>
> > ---
> > This is a repost of http://www.spinics.net/lists/linux-tegra/msg02117.html
> > I'm including it here since it's not in linux-next yet, and patch 3 depends
> > on it.
> 
> I assume I should wait for patches 1+3 to appear in -next via another tree
> before I merge patch 2 -- let me know if that's incorrect.

I don't think there's actually any need for that; initializing Tegra's
SDHCI from device-tree has never worked in mainline to date; it relies
on patch 1 being there. And if patch 2 was there without patch 3,
the worst that will happen is some port runs in 4-bit mode instead of
8-bit, which evidently works fine since I didn't even notice 8-bit
support was missing...

Thanks for checking though.

-- 
nvpublic

