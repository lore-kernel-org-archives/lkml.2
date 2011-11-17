Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1KQTje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:39:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17569 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1KQTjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:39:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 17 Nov 2011 11:39:15 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 17 Nov 2011 11:39:14 -0800
Subject: RE: [PATCH 01/10] arm/tegra: initial device tree for tegra30
Thread-Topic: [PATCH 01/10] arm/tegra: initial device tree for tegra30
Thread-Index: AcylRU5C9Gy7NjsOShOBQhXE+oIx0QAGtNTA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74C46@HQMAIL01.nvidia.com>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
 <1321546766-26770-2-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1321546766-26770-2-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Thursday, November 17, 2011 9:19 AM:
> This patch adds the initial device tree for tegra30

> diff --git a/Documentation/devicetree/bindings/arm/tegra.txt
...
> +* harmony: tegra20 based development board
> +Required root node properties:
> + - compatible = "nvidia,harmony", "nvidia,tegra20";
> +
> +* seaboard: tegra20 based clamshell reference design
> +Required root node properties:
> + - compatible = "nvidia,seaboard", "nvidia,tegra20";

Do we really want to list all the board names here? In the future, there
could be tens or hundreds. I would argue that we should just document
nvidia,tegra20 and nvidia,tegra30.

At a later point, we should fix board-dt.c to solely look for those
compatible values, although this will have to wait until the pinmux DT
bindings are present. Then, the kernel won't care about the board names.

-- 
nvpublic

