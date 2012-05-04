Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab2EDFiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 01:38:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54663 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316Ab2EDFiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 01:38:17 -0400
MIME-Version: 1.0
In-Reply-To: <201205031350.35476.arnd@arndb.de>
References: <201205031350.35476.arnd@arndb.de>
Date: Thu, 3 May 2012 22:38:15 -0700
Message-ID: <CAK2p4sJj7FRVSStVkqmn16sUv8S3vHmUYCU_VzTWAWzqV5yVsg@mail.gmail.com>
Subject: Re: Making ARM multiplatform kernels DT-only?
From: Deepak Saxena <dsaxena@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, shawn.guo@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2012 06:50, Arnd Bergmann <arnd@arndb.de> wrote:
> Hi everyone,
>
> I've been discussing multiplatform kernels with a few people recently,
> and we will have a lot of discussion sessions about this at Linaro
> Connect in Hong Kong.
>
> One question that came up repeatedly is whether we should support all
> possible board files for each platform in a multiplatform kernel,
> or just the ones that are already using DT probing. I would like
> to get a quick poll of opinions on that and I've tried to put those
> people on Cc that would be most impacted by this, i.e. the maintainers
> for platforms that have both DT and non-DT board files at the moment.
>
> My feeling is that we should just mandate DT booting for multiplatform
> kernels, because it significantly reduces the combinatorial space
> at compile time, avoids a lot of legacy board files that we cannot
> test anyway, reduces the total kernel size and gives an incentive
> for people to move forward to DT with their existing boards.

+1

I'm of the opinion that we support DT only platforms for
multi-platform but this is based on the approach of only caring for
multi-platform for newer systems and not worrying too much for legacy
HW.  I look at this from the perspective of how much return do we get
on investing effort into making it possible for every platform to be
built as part of consolidated zImage.  I don't expect distros (the
main users of a single zImage IMHO) to spend many cycles on older
platforms and those of us who still have some of them sitting around
to use are generally developers who are going to be doing a lot of
builds anyways...

~Deepak
