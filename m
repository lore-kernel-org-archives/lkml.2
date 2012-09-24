Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab2IXQqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:46:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63500 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab2IXQqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:46:17 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <20120925020744.cc5beb9e65473605e5ca2240@canb.auug.org.au>
References: <20120925005328.f748dfa3d077cebb345a4291@canb.auug.org.au>
	<50607E99.6040303@xenotime.net>
	<20120925020744.cc5beb9e65473605e5ca2240@canb.auug.org.au>
Date: Mon, 24 Sep 2012 09:46:15 -0700
Message-ID: <CAOesGMjYE0WgPr4ahPUdBVCZP=dkVPia-dmpDKgiOM_2HgsJgg@mail.gmail.com>
Subject: Re: linux-next: Tree for Sept 24 (irqchip)
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Chris Boot <bootc@bootc.net>, Dom Cobley <popcornmix@gmail.com>,
        Dom Cobley <dc4@broadcom.com>, Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 9:07 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Randy,
>
> On Mon, 24 Sep 2012 08:39:05 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>>
>> On 09/24/2012 07:53 AM, Stephen Rothwell wrote:
>>
>> > Today was a train wreck, with lots of new conflicts across several trees
>> > and a few build failures as well.
>>
>> I agree.  I mostly get this:
>>
>> drivers/Kconfig:157: can't open file "drivers/irqchip/Kconfig"
>>
>> i.e., no such file.
>>
>> How does this happen?  :(
>>
>> who handles irqchip?
>
> Hmm, commit 89214f009c1d ("ARM: bcm2835: add interrupt controller
> driver") from the arm-soc tree adds that file as an empty file (I have
> the empty file in my tree).  Nothing adds anything to it.

Yeah, the directory came in through arm-soc for-next (since the
bcm2835 driver was added), but there is an empty Kconfig in arm-soc. I
can see it in linux-next as well.

I wonder why it doesn't show up in your tree, Randy. You just did a
regular git checkout?


-Olof
