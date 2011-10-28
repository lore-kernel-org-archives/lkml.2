Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab1J1VWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:22:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43217 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab1J1VWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:22:49 -0400
Message-ID: <4EAB1D25.9060002@gmail.com>
Date: Fri, 28 Oct 2011 16:22:45 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Axel Lin <axel.lin@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>,
        linux-kernel@vger.kernel.org, "Stephen Rothwell sfr"@canb.auug.org.au,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [linux-next 20111025] build failure with make u8500_defconfig
References: <1319685104.4598.3.camel@phoenix> <CACRpkda7Q4q5YoWHbvC-gkcE99h0nUr3QhFT+GGuLGA4=V9gqg@mail.gmail.com>
In-Reply-To: <CACRpkda7Q4q5YoWHbvC-gkcE99h0nUr3QhFT+GGuLGA4=V9gqg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2011 02:32 PM, Linus Walleij wrote:
> On Thu, Oct 27, 2011 at 5:11 AM, Axel Lin <axel.lin@gmail.com> wrote:
> 
>> I got below build error by "make u8500_defconfig" on linux-next 20111025.
>>
>>  CC      arch/arm/common/gic.o
>> arch/arm/common/gic.c: In function 'gic_dist_init':
>> arch/arm/common/gic.c:290: error: 'irq_start' undeclared (first use in this function)
>> arch/arm/common/gic.c:290: error: (Each undeclared identifier is reported only once
>> arch/arm/common/gic.c:290: error: for each function it appears in.)
>> arch/arm/common/gic.c:296: error: 'struct gic_chip_data' has no member named 'irq_offset'
>> arch/arm/common/gic.c: In function 'gic_init':
>> arch/arm/common/gic.c:620: error: 'THIS_MODULE' undeclared (first use in this function)
>> make[1]: *** [arch/arm/common/gic.o] Error 1
>> make: *** [arch/arm/common] Error 2
> 
> Hm I don't get it, the lines in the compile error seems to come from the
> "ARM: gic: consolidate PPI handling" patch, so Marc if this is my
> fault can you help me out in advicing me on how to fix it up properly?
> 

It's a known issue and will get fixed when Arnd pulls my updated branch
for GIC DT support.

Rob
