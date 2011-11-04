Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1KDU3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:29:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4677 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1KDU3e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:29:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Nov 2011 13:29:16 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 4 Nov 2011 13:29:15 -0700
Subject: RE: [PATCH v2 1/8] arm/tegra: initial device tree for tegra30
Thread-Topic: [PATCH v2 1/8] arm/tegra: initial device tree for tegra30
Thread-Index: AcyZaQCmyXYQjo54STyiXcMVEIJRKQBxznTA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A4E3D@HQMAIL01.nvidia.com>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
 <1320242948-21061-2-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1320242948-21061-2-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Wednesday, November 02, 2011 8:09 AM:
> This patch adds the initial device tree for tegra30
...
> diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
...
> +	intc: interrupt-controller@50041000 {
> +		compatible = "nvidia,tegra30-gic", "nvidia,tegra20-gic";
> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +		reg = < 0x50041000 0x1000 >,
> +		< 0x50040100 0x0100 >;

The indentation of that last line isn't quite right; I think the < are
usually aligned.

-- 
nvpublic

