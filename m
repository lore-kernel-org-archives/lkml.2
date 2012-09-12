Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475Ab2ILQmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:42:51 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4043 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab2ILQms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:42:48 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Chris Brand" <chris.brand@broadcom.com>
To: "Arnd Bergmann" <arnd@arndb.de>, "Chris Ball" <cjb@laptop.org>
cc: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross" <ccross@android.com>, "Olof Johansson" <olof@lixom.net>,
        "Liam Girdwood" <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 09/16] ARM: tegra: move platform_data definitions
Thread-Topic: [PATCH 09/16] ARM: tegra: move platform_data definitions
Thread-Index: AQHNkB7G1DY5ejREz0GkV8meIYAqzpeFSc8lgACKn4CAARYoAA==
Date: Wed, 12 Sep 2012 16:42:31 +0000
Message-ID: <4EE5B48738DDED408878C97C8E050A8B0FAF5C@SJEXCHMB05.corp.ad.broadcom.com>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-9-git-send-email-arnd@arndb.de>
 <871ui8y3at.fsf@octavius.laptop.org> <201209111705.37490.arnd@arndb.de>
In-Reply-To: <201209111705.37490.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.4.246]
MIME-Version: 1.0
X-WSS-ID: 7C4E64B53MK32026017-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You'll want to check that you don't have any cases where two files use the same guard, I'd think.

Chris

-----Original Message-----
From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-kernel-bounces@lists.infradead.org] On Behalf Of Arnd Bergmann
Sent: September 11, 2012 10:06 AM
To: Chris Ball
Cc: Mark Brown; Russell King; Stephen Warren; Dmitry Torokhov; linux-kernel@vger.kernel.org; linux-tegra@vger.kernel.org; Colin Cross; Olof Johansson; Liam Girdwood; linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/16] ARM: tegra: move platform_data definitions

On Tuesday 11 September 2012, Chris Ball wrote:
> On Tue, Sep 11 2012, Arnd Bergmann wrote:
> > diff --git a/arch/arm/mach-tegra/include/mach/sdhci.h
> > b/include/linux/platform_data/mmc-sdhci-tegra.h
> > similarity index 100%
> > rename from arch/arm/mach-tegra/include/mach/sdhci.h
> > rename to include/linux/platform_data/mmc-sdhci-tegra.h
> 
> Looks like you aren't renaming the idempotency guards, so e.g.
> include/linux/platform_data/mmc-sdhci-tegra.h will contain:
> 
> #ifndef __ASM_ARM_ARCH_TEGRA_SDHCI_H
> #define __ASM_ARM_ARCH_TEGRA_SDHCI_H
> 
> Is that intentional?  Thanks,
> 

No, it's not intentional. We actually have a lot of instances that
are already wrong. Do we care enough to change the ones I'm moving here?

	Arnd

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


