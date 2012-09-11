Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506Ab2IKPfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:35:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58710 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376Ab2IKPft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:35:49 -0400
Message-ID: <504F5A51.9000506@wwwdotorg.org>
Date: Tue, 11 Sep 2012 09:35:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Chris Ball <cjb@laptop.org>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 09/16] ARM: tegra: move platform_data definitions
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-1-git-send-email-arnd@arndb.de> <1347368390-31252-9-git-send-email-arnd@arndb.de>
In-Reply-To: <1347368390-31252-9-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 06:59 AM, Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the tegra include directories

I have already submitted patches for some of these:

>  .../linux/platform_data/asoc-tegra_wm8903.h                        |    0

03f6743 ASoC: tegra: move platform data header

This moves the file to include/sound/tegra_wm8903.h, which seems
consistent with other sound-related platform data.

>  .../mach/kbc.h => include/linux/platform_data/keyboard-tegra-kbc.h |    0

a85442a Input: tegra - move platform data header

This moves the file to include/linux/input/tegra_kbc.h, which seems
consistent with other input-related platform data.

>  .../mach/sdhci.h => include/linux/platform_data/mmc-sdhci-tegra.h  |    0

I have a not-yet-applied (but ack'd by Chris Ball) patch to move this to
include/linux/mmc/tegra_sdhci.h. I believe all the dependencies are
staged in the Tegra tree now, so I can apply it if you want. I'm fine
with you apply this patch though; just let me know. If you want to take
your patch, then this part:

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
