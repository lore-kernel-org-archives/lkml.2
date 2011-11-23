Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1KWRZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:25:55 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6489 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab1KWRZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:25:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 23 Nov 2011 09:25:39 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Marc Dietrich <marvin24@gmx.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Wed, 23 Nov 2011 09:25:36 -0800
Subject: RE: [PATCH] arm/tegra: convert tegra20 to GIC devicetree binding
Thread-Topic: [PATCH] arm/tegra: convert tegra20 to GIC devicetree binding
Thread-Index: AcypnMnneKlilYzZSg2CJ0lRNHgjNAAZ+CmA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174F08C6F0@HQMAIL01.nvidia.com>
References: <1321542430-17971-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74C1E@HQMAIL01.nvidia.com>
 <20111118120352.GZ19069@tbergstrom-lnx.Nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74E63@HQMAIL01.nvidia.com>
 <20111121122212.GL19069@tbergstrom-lnx.Nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF174F08C0E5@HQMAIL01.nvidia.com>
 <20111123050012.GS19069@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20111123050012.GS19069@tbergstrom-lnx.Nvidia.com>
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

Peter De Schrijver wrote at Tuesday, November 22, 2011 10:00 PM:
...
> I think we need to model the GPIO IRQs as a seperate interrupt controller.
> That way the WM8903 node can refer to the GPIO IRQ as an IRQ without
> hardcoding the global interrupt number, similar to the way we specify the
> SPI number in the device nodes and not the global interrupt number.

Yes, you're right.

I'd originally thought that the GPIO IRQs fed directly into the GIC, but
now that I read the docs, I see that the GPIO controller really is an
interrupt aggregator/controller.

-- 
nvpublic

