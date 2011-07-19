Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1GSW4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:56:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4487 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1GSW4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:56:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 19 Jul 2011 15:56:31 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Andrew Chew <AChew@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "olof@lixom.net" <olof@lixom.net>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@vger.kernel.org" <linux-arm-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Chew <AChew@nvidia.com>
Date: Tue, 19 Jul 2011 15:56:29 -0700
Subject: RE: [PATCH 1/3] usb: tegra20-ehci: Add devicetree support.
Thread-Topic: [PATCH 1/3] usb: tegra20-ehci: Add devicetree support.
Thread-Index: AcxGZjayVyxfM2IySzyuSZtUuCgdLwAAKL5Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049EBDED24@HQMAIL01.nvidia.com>
References: <1311115617-9697-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1311115617-9697-1-git-send-email-achew@nvidia.com>
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

achew@nvidia.com wrote at Tuesday, July 19, 2011 4:47 PM:
> From: Andrew Chew <achew@nvidia.com>
> 
> Add code to try to get platform data information (register base, irq,
> modes, various tuning parameters) from device tree, if not present in board
> files.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  .../devicetree/bindings/usb/tegra20-ehci.txt       |   27 +++
>  arch/arm/mach-tegra/include/mach/usb_phy.h         |    2 +-
>  drivers/usb/host/ehci-tegra.c                      |  197 +++++++++++++++++++-
>  3 files changed, 219 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/tegra20-ehci.txt

I sent a variety of comments on this patch internally to Andrew, but the
email crossed paths with the posting to the public mailing lists. I won't
bother repeating those comments here, but I assume they'll be addressed
in a new version of this patch.

-- 
nvpublic

