Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666Ab2IKRML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:12:11 -0400
Received: from void.printf.net ([89.145.121.20]:58084 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020Ab2IKRMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:12:07 -0400
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
	<1347368390-31252-9-git-send-email-arnd@arndb.de>
	<871ui8y3at.fsf@octavius.laptop.org>
	<201209111705.37490.arnd@arndb.de>
Date: Tue, 11 Sep 2012 13:11:55 -0400
In-Reply-To: <201209111705.37490.arnd@arndb.de> (Arnd Bergmann's message of
	"Tue, 11 Sep 2012 17:05:37 +0000")
Message-ID: <87sjaowkkk.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 11 2012, Arnd Bergmann wrote:
>> Looks like you aren't renaming the idempotency guards, so e.g.
>> include/linux/platform_data/mmc-sdhci-tegra.h will contain:
>> 
>> #ifndef __ASM_ARM_ARCH_TEGRA_SDHCI_H
>> #define __ASM_ARM_ARCH_TEGRA_SDHCI_H
>> 
>> Is that intentional?  Thanks,
>
> No, it's not intentional. We actually have a lot of instances that
> are already wrong. Do we care enough to change the ones I'm moving here?

It's clearly not a big deal.  I did fix it in Stephen's previous version
of this change, though.

Maybe just add a note to the commit message explaining that you aren't
changing the guards and driver maintainers might want to fix them up if
it's something they care about?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
