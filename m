Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab2EEN1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 09:27:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab2EEN1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 09:27:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: Making ARM multiplatform kernels DT-only?
Date: Sat, 5 May 2012 13:17:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        linaro-dev@lists.linaro.org, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
References: <201205031350.35476.arnd@arndb.de> <201205041624.17850.arnd@arndb.de> <20120505080936.GP4141@pengutronix.de>
In-Reply-To: <20120505080936.GP4141@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201205051317.40357.arnd@arndb.de>
X-Provags-ID: V02:K0:JJeUroR2+FAV8yqUb+UV2ecNibHoIGw50YTK0k+xGLq
 B2H/6/Nsx9QVGluSbok08EeyxzWGocDuP3QJkabYyhqDmsfcW+
 IB+stYgZTKktdrJstvnxk+4IgqQ0H2UMbiwX1tZwi8vWhAi81h
 v39M+cfZU2mdScYOfguLSWTd2HBUVLkkWgnGCXPT622SKOUI+n
 BqOkD2bFuDwF6D0zci2xaI5UsJoKeV0brY7ZZTAnvzBPAS03ch
 sT9g1P8ZSPkhah0JS5Mhn5yQjN4l2+f4JUsBpHqVqfwF1gCoqC
 qD3A8ul3qr/795cupX8KKaX66+P/k+FMczb4n9YI9xHQhjKOJk
 wVxXkewe7zT9hODVn4sY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 May 2012, Sascha Hauer wrote:
> They should not if they are not interested in these boards, but why
> shouldn't I be able to enable these 25 boards plus a few atmel or pxa
> boards?
> 
> When there are technical reasons to limit a multiplatform Kernel to DT
> only, then fine, lets do it that way. If there are no technical reasons
> and this limitation shall only be used to put some political pressure on
> platform board maintainers, then I am against it. Look around, people
> actually are porting their boards over to device tree, I don't think
> that such pressure is necessary.

It's definitely not a hard technical reason, just me trying to find
ways to simplify the problem space an any possible way. Basically all
code that can get built into the kernel has the ability to break other
stuff and causes bloat, see the recent discussion about putting
late_initcall into the machine_desc.

> Only my two cents, it's not that important to me since I want to port my
> (relevant) boards over to DT anyway, so I won't argue about this.

Ok, thanks for your input!

>From the statements made so far, I can see no clear policy that we can
apply to everyone. My take on this is that for any work I spend on
multiplatform kernel, I concentrate on the DT-based board files and
get them to work together first, but leave it up to the individual
subarch maintainers whether they want to add other board files into
the mix.

	Arnd
