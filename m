Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab1J0TqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 15:46:13 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2249 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1J0TqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 15:46:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 27 Oct 2011 12:45:58 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 27 Oct 2011 12:45:56 -0700
Subject: RE: [PATCH 1/6] arm/tegra: initial device tree for tegra30
Thread-Topic: [PATCH 1/6] arm/tegra: initial device tree for tegra30
Thread-Index: AcyTNr/pRuzvL7kGTgiCMDnC6e9XUQBqe5Yg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B499C@HQMAIL01.nvidia.com>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
 <1319561644-6160-2-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1319561644-6160-2-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Tuesday, October 25, 2011 10:54 AM:
> From: Peter De Schrijver <pdeschrijver@nvidia.com>
>
> This patch adds the initial device tree for tegra30

It'd be nice if you could configure git send-email so it knows your name;
that way the From email header will include it.

> diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
> new file mode 100644
> index 0000000..3550b9a
> --- /dev/null
> +++ b/arch/arm/boot/dts/tegra30.dtsi
> @@ -0,0 +1,128 @@
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	model = "NVIDIA Tegra 30";

Separately later, I don't suppose you could send a patch to add a model
field to tegra20.dtsi too?

Otherwise, this patch seems fine.

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

