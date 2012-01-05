Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab2AEUiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:38:46 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3253 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab2AEUip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:38:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Jan 2012 12:38:36 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 5 Jan 2012 12:38:35 -0800
Subject: RE: [PATCH v2] arm/tegra: add support for tegra30 interrupts
Thread-Topic: [PATCH v2] arm/tegra: add support for tegra30 interrupts
Thread-Index: AczLrm5anB+8e7c5TZucYAByazD6UAAO2qtw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17761F17AB@HQMAIL01.nvidia.com>
References: <1325770305-21637-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1325770305-21637-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Thursday, January 05, 2012 6:32 AM:
> Tegra30 has 1 extra legacy interrupt controller. Use the GIC ITLinesNumber
> field to determine how many interrupt controllers we have and initialize
> appropriately. Also make room for the extra tegra30 interrupts by moving
> the GPIO IRQ base. This shouldn't affect existing code as it determines the
> correct IRQ number for GPIOs using TEGRA_GPIO_TO_IRQ().

Due to a typo in ARM patch 7240/1, this current patch also relies on
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7271/1

-- 
nvpublic

