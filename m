Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab1HZFTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 01:19:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64057 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab1HZFTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 01:19:35 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1314123334-23133-1-git-send-email-swarren@nvidia.com>
References: <1314123334-23133-1-git-send-email-swarren@nvidia.com>
Date: Thu, 25 Aug 2011 22:19:34 -0700
Message-ID: <CAOesGMgS0LZdSA9LFvn+_bkdnKfT4d3n6mZCe=vpTGK1c1y+cg@mail.gmail.com>
Subject: Re: [PATCH 1/2] sdhci/tegra: Add Device Tree probing support
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>,
        Shawn Guo <shawn.guo@linaro.org>, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 11:15 AM, Stephen Warren <swarren@nvidia.com> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
> Add hooks to read gpio configuration out of the device tree node.
>
> [grant.likely: Rewrite of original patch from John Bonesio]
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> [swarren: Fixed tegra_sdhci_get_ro() to retrieve pdata correctly]
> [swarren: Reworked to avoid #ifdef CONFIG_OF]
> [swarren: Reworked binding based on fsl-imx-esdhc.txt]
> [swarren: Documented binding]
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
