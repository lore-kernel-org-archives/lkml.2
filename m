Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab1H3Tbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:31:41 -0400
Received: from void.printf.net ([89.145.121.20]:54016 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab1H3Tbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:31:38 -0400
From: Chris Ball <cjb@laptop.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra\@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss\@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] arm/dt: Tegra: Update SDHCI nodes to match bindings
References: <1314731837-6985-1-git-send-email-swarren@nvidia.com>
	<m2hb4yso44.fsf@bob.laptop.org>
	<74CDBE0F657A3D45AFBB94109FB122FF04B3279E01@HQMAIL01.nvidia.com>
Date: Tue, 30 Aug 2011 15:31:28 -0400
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B3279E01@HQMAIL01.nvidia.com>
	(Stephen Warren's message of "Tue, 30 Aug 2011 12:26:16 -0700")
Message-ID: <m2d3fmsnlb.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 30 2011, Stephen Warren wrote:
> I don't think there's actually any need for that; initializing Tegra's
> SDHCI from device-tree has never worked in mainline to date; it relies
> on patch 1 being there. And if patch 2 was there without patch 3,
> the worst that will happen is some port runs in 4-bit mode instead of
> 8-bit, which evidently works fine since I didn't even notice 8-bit
> support was missing...

Ah, okay.  I've merged patch 2 to mmc-next for 3.2, then, and will keep
an eye on what happens with the arch patches.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
