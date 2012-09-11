Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab2IKPmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:42:18 -0400
Received: from void.printf.net ([89.145.121.20]:41462 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab2IKPmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:42:16 -0400
From: Chris Ball <cjb@laptop.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 09/16] ARM: tegra: move platform_data definitions
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
	<1347368390-31252-1-git-send-email-arnd@arndb.de>
	<1347368390-31252-9-git-send-email-arnd@arndb.de>
Date: Tue, 11 Sep 2012 11:42:02 -0400
In-Reply-To: <1347368390-31252-9-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Tue, 11 Sep 2012 14:59:43 +0200")
Message-ID: <871ui8y3at.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Sep 11 2012, Arnd Bergmann wrote:
> diff --git a/arch/arm/mach-tegra/include/mach/sdhci.h
> b/include/linux/platform_data/mmc-sdhci-tegra.h
> similarity index 100%
> rename from arch/arm/mach-tegra/include/mach/sdhci.h
> rename to include/linux/platform_data/mmc-sdhci-tegra.h

Looks like you aren't renaming the idempotency guards, so e.g.
include/linux/platform_data/mmc-sdhci-tegra.h will contain:

#ifndef __ASM_ARM_ARCH_TEGRA_SDHCI_H
#define __ASM_ARM_ARCH_TEGRA_SDHCI_H

Is that intentional?  Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
