Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab2DYAFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 20:05:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51530 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017Ab2DYAFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 20:05:09 -0400
Message-ID: <4F973FB2.1050004@samsung.com>
Date: Tue, 24 Apr 2012 17:05:06 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org
Subject: Re: arch/arm/mach-s3c2410/Kconfig is unsourced
References: <1335090082.1814.27.camel@x61.thuisdomein>
In-Reply-To: <1335090082.1814.27.camel@x61.thuisdomein>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 0) commit 85fd6d63bf2927b9da7ab1b0d46723bfdb13808c ("ARM: S3C2410: move
> mach-s3c2410/* into mach-s3c24xx/") orphaned
> arch/arm/mach-s3c2410/Kconfig: currently nothing sources that file in
> Linus' tree.
>
Oops, you're right.

> 1) I haven't looked in depth at this, but this made S3C2410_PLLTABLE
> disappear from the build system (ie, arch/arm/mach-s3c2410/pll.c is dead
> code now). Moreover, this basically turned both "select S3C2410_CPUFREQ
> if CPU_FREQ_S3C24XX", under "config CPU_S3C2410", and "select
> S3C2410_IOTIMING if S3C2410_CPUFREQ", under "config ARCH_BAST", into
> nops (both in arch/arm/mach-s3c24xx/Kconfig).
>
> 2) So to me it seems the move has only been done half: either more
> things needs to be moved or those things can be removed entirely. But
> perhaps arch/arm/mach-s3c2410/Kconfig should just be sourced again.
>
Yes, I think, would be better right now, if we could add just sourcing 
mach-s3c2410/Kconfig but as you said, I need to remove entire mach-s3c24 
stuff.

Thanks for your pointing out and let me fix it.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
