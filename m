Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1GESWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 14:22:46 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2345 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1GESWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 14:22:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 05 Jul 2011 11:22:37 -0700
From: Stephen Warren <swarren@nvidia.com>
To: "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 5 Jul 2011 11:22:30 -0700
Subject: Tegra device name for device tree
Thread-Topic: Tegra device name for device tree
Thread-Index: Acw7PqdLt3r4QwwLQT+Qh5CCihv6QA==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049E21BE97@HQMAIL01.nvidia.com>
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

Grant et. al.,

It recently dawned on me that all the Tegra DeviceTree support is using a
marketing name for the SoC ("tegra250"). NVIDIA would prefer that we use
engineering names for the SoC (e.g. "tegra20" now, "tegra30" for an
upcoming SoC). The primary motivation for this is that engineering names
tend to be more stable and map more directly to the HW design.

Is it still possible to make this change, if I submit the appropriate
patches to do this? 

So, far, I see devicetree/next only refers to the Tegra serial port,
whereas devicetree/arm and devicetree/test refer to more Tegra devices in
this way. I'm not quite sure how the flow of patches works between these 3
trees. For the serial port, I obviously need to submit a patch against
devicetree/next, but I'm not so sure about which of devicetree/arm or
devicetree/test to target for the other devices.

Sorry for bringing this up so late in the game.

Thanks!

-- 
nvpublic

