Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab2HVPiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:38:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51144 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab2HVPh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:37:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 2/4] [RFC] ARM: mass move of mach-*/plat-* header files
Date: Wed, 22 Aug 2012 15:37:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
References: <201208221253.07278.arnd@arndb.de> <201208221256.35657.arnd@arndb.de> <alpine.LFD.2.02.1208221126180.1754@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208221126180.1754@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221537.53904.arnd@arndb.de>
X-Provags-ID: V02:K0:iiYu1sxb1zA+haxHtQF+NbOT1y+qcLnuOl9qElLGDCj
 7hDhThMSxl1FHM2eByj7aqfL0NBfzEzWw0Jnt4Fu3mVpgYM7Ex
 f1xGJeyoQqUYXnfsqj8E7/ukgiawvylSWTfzcU73D4xn732zIB
 9Bjb0Gc9pf06258kpxs57uf3jRTwSkfMVPqBKQ+lOe95iWFmhd
 2CX+YV/gKhf53VvEW983YAvdiAvF1pe6xYHL6OpIY+gn/ewJ8n
 APQZunwAxbQ7HIaYfO3hZc5Fg8wNEQ5NxkAambmGh6kgYdHYrV
 TZdETChzhNq1hx9eP6D4HpikUhqyKwMY2ivFAh+T284w9xOvPs
 KfLar1cBxaDPBIsfrdzc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Nicolas Pitre wrote:
> Ideally, files such as ...
> 
> > rename from arch/arm/mach-at91/include/mach/at91_pio.h
> > rename to arch/arm/mach-at91/include/mach-at91/at91_pio.h
> 
> should move next to the A91 GPIO driver file.  but that require manual 
> operations which can be done later.

Right. There are cases where we have to do this eventually because the
files are duplicated, e.g. at91/avr32, pxa/mmp, s3c/s5p/exynos, or
sa1100/pxa.

For the majority of cases where it's desirable to move the header file
closer to the driver, it's not actually a prerequisite to do this
in order to get a complete multiplatform setup.

	Arnd
