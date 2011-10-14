Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab1JNPOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:14:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33580 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab1JNPOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:14:14 -0400
MIME-Version: 1.0
In-Reply-To: <20111013211145.GA27779@n2100.arm.linux.org.uk>
References: <4DC53134.8070706@gmail.com>
	<20110510234526.GC18929@game.jcrosoft.org>
	<BANLkTikvCiXgnm_hVTqDmzZ6yDf6H5WaCw@mail.gmail.com>
	<20111013211145.GA27779@n2100.arm.linux.org.uk>
Date: Fri, 14 Oct 2011 16:14:12 +0100
Message-ID: <CALp=RoUvAvoONPTqf3H256t1ykWr4VgFL5nd6AuvOr-6BQfJsQ@mail.gmail.com>
Subject: Re: [PATCH] AT91: Add external RTC for Flexibity board
From: Maxim Osipov <maxim.osipov@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Victor <avictor.za@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I'll do it. Thanks!
Maxim

On Thu, Oct 13, 2011 at 10:11 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, May 11, 2011 at 09:44:52AM +0200, Andrew Victor wrote:
>> hi,
>>
>> >> This patch enables external RTC support on AT91 Flexibity board.
>>
>> Acked-by: Andrew Victor <linux@maxim.org.za>
>>
>> Maxim: You can submit it to Russell's patch system.
>>
>>
>> > looks fine just one comment please add your board to the new at91sam9260_defconfig
>>
>> That file does not exist in any mainline kernel.
>
> It's been a while since this patch went into the patch system, and it
> didn't get applied for various reasons, including because it looked
> like it was sent there without any review (no acked-by's etc added to
> it.)
>
> What's the status of this - and if its still relevant can we have
> it with the proper attributations please?
>
