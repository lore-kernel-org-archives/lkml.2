Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632Ab2IKRFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:05:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60564 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759004Ab2IKRFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:05:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 09/16] ARM: tegra: move platform_data definitions
Date: Tue, 11 Sep 2012 17:05:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-tegra@vger.kernel.org
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-9-git-send-email-arnd@arndb.de> <871ui8y3at.fsf@octavius.laptop.org>
In-Reply-To: <871ui8y3at.fsf@octavius.laptop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209111705.37490.arnd@arndb.de>
X-Provags-ID: V02:K0:gjjTlguWLfmCKUg5DIhptCTVVeLVHmXmIz0ChN3LC1k
 zVRIDwI/PPnI/IRxJFdUqkVDWXn17kmpn/5l1S3niEpR5JIlAM
 DAsYPEmJOYpE3FYYS61g3co7tGqykqD8eO7TcIWBj2Kq1IVVry
 Q1WMNQXRyvDUbW8tVWXqm/2vdYRuxeBPaWZu5HlnmPU0D0kwmF
 v6qdBc/SYFYOixF92Eu4+LRBv5JPWFUDI4e2xDJ7/CQPtuVgRh
 R53Y5anNRUoosQsbEYrLFCdmE8JTePOaDndUA+HupFqwMvM1YZ
 UiKoqXRYyJLH1uOwbm8eLtzB+8Uahr0m+MnH3fdIMRM01wlzKO
 0uRoIa9diAAMDo3jE3RI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
