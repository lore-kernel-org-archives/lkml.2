Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2KMH4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:56:55 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3934 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab2KMH4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:56:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 12 Nov 2012 23:56:48 -0800
Message-ID: <50A1FE01.5090808@nvidia.com>
Date: Tue, 13 Nov 2012 10:00:01 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] drm: Add NVIDIA Tegra20 support
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de> <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.11.2012 15:59, Thierry Reding wrote:
> This commit adds a KMS driver for the Tegra20 SoC. This includes basic
> support for host1x and the two display controllers found on the Tegra20
> SoC. Each display controller can drive a separate RGB/LVDS output.

Thanks Thierry for the hard work. I noticed the same thing Stephen
noticed earlier - I couldn't compile the driver.

Other than that, there were a couple of differences to the tree we've
worked with and tested earlier: Tegra30 support was dropped and as a
consequence so was IOMMU support.

I'm perfectly fine with leaving out IOMMU support, because we had some
problems with that and dma-buf. We were getting a bit worried about how
to implement mapping and re-mapping dma-buf's without causing duplicate
IOMMU mappings.

Best regards,
Terje
