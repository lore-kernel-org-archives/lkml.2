Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2AIDD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 22:03:59 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48896 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861Ab2AIDD6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 22:03:58 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120109125531.dbcac0481adb6376fb7e9ca1@canb.auug.org.au>
References: <20120109125531.dbcac0481adb6376fb7e9ca1@canb.auug.org.au>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 9 Jan 2012 11:03:35 +0800
Message-ID: <CAF+7xWktUYvz1UqNyYsgAwEeap6UefXz+YE1wrRydrCWiMKAAg@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the sound-asoc tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/9 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,
>
> After merging the sound-asoc tree, today's linux-next build (powerpc
> ppc64_defconfig and x86_64 allmodconfig) produced this warning:
>
> drivers/misc/Kconfig:212:error: recursive dependency detected!
> drivers/misc/Kconfig:212:       symbol ATMEL_SSC is selected by SND_ATMEL_SOC_SSC
> sound/soc/atmel/Kconfig:9:      symbol SND_ATMEL_SOC_SSC is selected by SND_AT91_SOC_SAM9G20_WM8731
> sound/soc/atmel/Kconfig:18:     symbol SND_AT91_SOC_SAM9G20_WM8731 depends on ATMEL_SSC
>
> Probably introduced by commit 739be96ab837 ("ASoC: Fix build dependency
> for SND_ATMEL_SOC_SSC").
Hi Mark,
I think this commit should be replaced by [PATCH] ASoC: Fix build
dependency for SND_AT91_SOC_AFEB9260
http://mailman.alsa-project.org/pipermail/alsa-devel/2012-January/047861.html

Should I send a revert patch for commit 739be96ab837? Or you can do it
by git-revert command directly?

Thanks,
Axel
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
