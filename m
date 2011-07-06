Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1GFFzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 01:55:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59025 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1GFFzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 01:55:42 -0400
Date: Tue, 5 Jul 2011 23:55:39 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 0/3] tegra: Use engineering names in DT compatible
 properties
Message-ID: <20110706055539.GG9978@ponder.secretlab.ca>
References: <1309897762-23564-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309897762-23564-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 02:29:19PM -0600, Stephen Warren wrote:
> Grant, these 3 patches are for the devicetree/test branch. I kept them
> separated in the hope they'll squash into existing patches already there.

Thanks, I'll pick them up and squash them in.

g.

> 
> Stephen Warren (3):
>   mmc/tegra: Use engineering names in DT compatible property
>   ARM: tegra: Use engineering names in DT compatible property
>   dt: docs: tegra: Use engineering names in DT compatible property
> 
>  Documentation/devicetree/usage-model |   12 ++--
>  arch/arm/boot/dts/tegra-harmony.dts  |    4 +-
>  arch/arm/boot/dts/tegra-seaboard.dts |    4 +-
>  arch/arm/boot/dts/tegra20.dtsi       |  162 ++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/tegra250.dtsi      |  162 ----------------------------------
>  arch/arm/mach-tegra/board-dt.c       |   32 ++++----
>  drivers/mmc/host/sdhci-pltfm.c       |    2 +-
>  7 files changed, 189 insertions(+), 189 deletions(-)
>  create mode 100644 arch/arm/boot/dts/tegra20.dtsi
>  delete mode 100644 arch/arm/boot/dts/tegra250.dtsi
> 
