Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1GSXEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:04:33 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9925 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1GSXEb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:04:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 19 Jul 2011 16:04:23 -0700
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
Date: Tue, 19 Jul 2011 16:04:22 -0700
Subject: RE: [PATCH 3/3] dt: tegra20: Add ehci nodes to Seaboard.
Thread-Topic: [PATCH 3/3] dt: tegra20: Add ehci nodes to Seaboard.
Thread-Index: AcxGZjkx5ggFPfwHSci0NC6oKmMXGAAAYWJQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049EBDED2A@HQMAIL01.nvidia.com>
References: <1311115617-9697-1-git-send-email-achew@nvidia.com>
 <1311115617-9697-3-git-send-email-achew@nvidia.com>
In-Reply-To: <1311115617-9697-3-git-send-email-achew@nvidia.com>
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
> Signed-off-by: Andrew Chew <achew@nvidia.com>

Removing status="disabled" from tegra20.dtsi makes this patch obsolete.

Although that said, since many of the USB properties are board-specific
and determined by system characterization, they aren't generally
applicable to all Tegra devices. As such, should those values be moved
into tegra-seaboard.dts instead? Perhaps tegra20.dtsi should specify
the default values that the driver currently uses if not supplied with
platform data though... I think the Seaboard values are the defaults,
which still would make this patch obsolete.

> ---
>  arch/arm/boot/dts/tegra-seaboard.dts |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
> index 5a99b4c..c5a1b71 100644
> --- a/arch/arm/boot/dts/tegra-seaboard.dts
> +++ b/arch/arm/boot/dts/tegra-seaboard.dts
> @@ -31,4 +31,16 @@
>  	sdhci@c8000600 {
>  		status = "ok";
>  	};
> +
> +	ehci@c5000000 {
> +		status = "ok";
> +	};
> +
> +	ehci@c5004000 {
> +		status = "ok";
> +	};
> +
> +	ehci@c5008000 {
> +		status = "ok";
> +	};
>  };
> --
> 1.7.6

-- 
nvpublic

