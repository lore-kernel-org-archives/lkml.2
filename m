Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0CYWgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:36:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50735 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab0CYWgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:36:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=h9GIBcva9lJuNAyaCckL65/j2xteTZ0C1jT3IC3EDjbuYEZ0lkje+nujD7AbPV4rbQ
         4R60L4O4Chs/qtkyYdPy4pfLYe8+lJVmZYMtiNXyklQTU4BQz7SBFm5KHKcfrM7YgZoL
         E+CroO4orDaWZyeldG9p5r1BeU4hLAGr4dqu0=
MIME-Version: 1.0
In-Reply-To: <63386a3d1003250820x3cf81000i9d27e95c755b9ca8@mail.gmail.com>
References: <4BAAD5BB.7050101@samsung.com>
	 <1b68c6791003242234h106d9530p12b5a046a906227e@mail.gmail.com>
	 <63386a3d1003250130w6f34854ag2ca163799e9b7bed@mail.gmail.com>
	 <1b68c6791003250517y4e2789baoe147e5982c363682@mail.gmail.com>
	 <63386a3d1003250820x3cf81000i9d27e95c755b9ca8@mail.gmail.com>
Date: Fri, 26 Mar 2010 07:36:08 +0900
Message-ID: <1b68c6791003251536q7ce451b1yc874f6e0347ab595@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: jassi brar <jassisinghbrar@gmail.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, dan.j.williams@intel.com,
       kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 12:20 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/3/25 jassi brar <jassisinghbrar@gmail.com>:
>> And if this patch is accepted, there
>> _will_ exist two copies of the PL330 driver -- one in drivers/dma/pl330_dmac.c
>> and another in arch/arm/plat-samsung/. Only the former will be lying unused
>> until some other SoC vendor decided to use PL330, because S3C has come too
>> long a way to change its drivers to driver/dma/ API and modify DMA
>> drivers for every SoC.
>
> What's wrong with merging them later then? Refactoring FTW.
The amount of code that will be modified or taken out of drivers/dma/pl330_dmac
will so much that I will be left only with constrained data structures in
the file to do tricks to make it work with the PL330 engine driver.
I am not very keen on authoring the driver/dma/ driver but neither am I
interested in having to cleanup someone else' code.

>> I have the pl330-core part almost ready, but i need time to implement
>> some _testable_
>> implementation of the scheme. If maintainers want to see structure of
>> my code, I can
>> share it too, but I think I pretty much made it clear.
>
> Why not just post it on the list? I'm curious! Since I'm working on a PrimeCell
> DMA API I would love to look at PrimeCell DMA engine drivers.
I'll post in a day or two when the PL330 core driver takes come shape
closer to what it is supposed to look.
That will help me getting suggestions for improvement, i hope.

regards.
