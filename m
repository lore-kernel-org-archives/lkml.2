Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1J1Tcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 15:32:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60059 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1J1Tci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 15:32:38 -0400
MIME-Version: 1.0
In-Reply-To: <1319685104.4598.3.camel@phoenix>
References: <1319685104.4598.3.camel@phoenix>
Date: Fri, 28 Oct 2011 21:32:37 +0200
Message-ID: <CACRpkda7Q4q5YoWHbvC-gkcE99h0nUr3QhFT+GGuLGA4=V9gqg@mail.gmail.com>
Subject: Re: [linux-next 20111025] build failure with make u8500_defconfig
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        "Stephen Rothwell sfr"@canb.auug.org.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 5:11 AM, Axel Lin <axel.lin@gmail.com> wrote:

> I got below build error by "make u8500_defconfig" on linux-next 20111025.
>
>  CC      arch/arm/common/gic.o
> arch/arm/common/gic.c: In function 'gic_dist_init':
> arch/arm/common/gic.c:290: error: 'irq_start' undeclared (first use in this function)
> arch/arm/common/gic.c:290: error: (Each undeclared identifier is reported only once
> arch/arm/common/gic.c:290: error: for each function it appears in.)
> arch/arm/common/gic.c:296: error: 'struct gic_chip_data' has no member named 'irq_offset'
> arch/arm/common/gic.c: In function 'gic_init':
> arch/arm/common/gic.c:620: error: 'THIS_MODULE' undeclared (first use in this function)
> make[1]: *** [arch/arm/common/gic.o] Error 1
> make: *** [arch/arm/common] Error 2

Hm I don't get it, the lines in the compile error seems to come from the
"ARM: gic: consolidate PPI handling" patch, so Marc if this is my
fault can you help me out in advicing me on how to fix it up properly?

Yours,
Linus Walleij
