Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1LINzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:55:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65380 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab1LINzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:55:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
Date: Fri, 9 Dec 2011 13:55:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>, kernel@pengutronix.de,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de> <4693507.K6tP4YDUh2@wuerfel> <20111209092300.GR4585@pengutronix.de>
In-Reply-To: <20111209092300.GR4585@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201112091355.16720.arnd@arndb.de>
X-Provags-ID: V02:K0:bOnrS92qVafeooFdG19fpsXWMnCFcI/WvJ7IEKGXQbf
 ZBNSYyq69sBFPZoCHEkstd2t6OjGNzOo0bJXYH5Q/G/sFifrS3
 axRu0Y16SOLsA5DeqsOgL0mi1HsXx9lduoBCN/0Xnkm+nJLeJp
 7pmSvtzqvLZVfsvfpJHD6ogNtZC7zg6xHN5Q+R1VPUZdGysGVr
 ErTFGZJrodKTmEdTAPH94jHZ5JAx1L6IObFrL1ixaNrNgP+JUO
 7w2hz72p4qhfPJaxAZdLrvlGFncFwdvLz9JyqVCSBP3fP9dxLv
 qT/Y1HAU9ngMn0KarbW8vRfeLvYlNiaz3EB98yAYPe2F5UPb+o
 0HxHioblqwB2uPQaNKDM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 December 2011, Uwe Kleine-König wrote:
> On Thu, Dec 08, 2011 at 11:55:53PM +0100, Arnd Bergmann wrote:
> > On Thursday 08 December 2011 23:40:57 Uwe Kleine-König wrote:
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > ---
> > > Note that there is no support yet for efm32 in mainline, so ARCH_EFM32
> > > isn't defined.
> > 
> > Since the platform is not yet part of the architecture, it will have
> > to use device tree based probing when it gets added. I would suggest
> > only merging drivers for it that can deal with this and do not rely
> > on platform_data.
>
> I feared you will say that. These machines have at most 4MiB of RAM.
> I'll have to evaluate if dt is too heavy for them.

What's the state of the platform code? Is this based on Catalin's
Cortex-M3 tree? I've heard a few people express interest in getting
various M3 based SoCs supported mainline and I think that would
be a good idea, but I would also expect that device tree is one
of the lesser problems here.

	Arnd
