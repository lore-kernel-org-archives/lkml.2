Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2ECOXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:23:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39440 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab2ECOXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:23:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120503141853.GC897@n2100.arm.linux.org.uk>
References: <201205031350.35476.arnd@arndb.de>
	<20120503141853.GC897@n2100.arm.linux.org.uk>
Date: Thu, 3 May 2012 23:23:51 +0900
Message-ID: <CANqRtoRLmqLWfUYZRy8yuPWXybj0=RGxmYDEfuH+kqjT_009Jw@mail.gmail.com>
Subject: Re: Making ARM multiplatform kernels DT-only?
From: Magnus Damm <magnus.damm@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Deepak Saxena <dsaxena@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, shawn.guo@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 11:18 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, May 03, 2012 at 01:50:35PM +0000, Arnd Bergmann wrote:
>> My feeling is that we should just mandate DT booting for multiplatform
>> kernels, because it significantly reduces the combinatorial space
>> at compile time, avoids a lot of legacy board files that we cannot
>> test anyway, reduces the total kernel size and gives an incentive
>> for people to move forward to DT with their existing boards.
>
> On this point, I strongly object, especially as I'm one who uses the
> existing non-DT multiplatform support extensively.  It's really not
> a problem for what you're trying to achieve.

Perhaps not so surprisingly, but I'm with Russell on this one.

I'd like our work-in-progress DT support to coexist with all non-DT platforms.

Thanks,

/ magnus
