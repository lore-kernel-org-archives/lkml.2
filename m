Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2LCUUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:20:07 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:60257 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2LCUUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:20:05 -0500
Message-ID: <50BD0968.3060405@free-electrons.com>
Date: Mon, 03 Dec 2012 21:19:52 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: sunxi: Include linux/delay.h
References: <1354462339.24917.0.camel@phoenix>
In-Reply-To: <1354462339.24917.0.camel@phoenix>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/12/2012 16:32, Axel Lin a écrit :
> This fixes below build error:
> 
>   CC      arch/arm/mach-sunxi/sunxi.o
> arch/arm/mach-sunxi/sunxi.c: In function 'sunxi_restart':
> arch/arm/mach-sunxi/sunxi.c:55:3: error: implicit declaration of function 'mdelay' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[1]: *** [arch/arm/mach-sunxi/sunxi.o] Error 1
> make: *** [arch/arm/mach-sunxi] Error 2

A similar patch has already been merged by Arnd:
http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=commit;h=5e51651de30677f9d36805de9c261bf80f415790

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
