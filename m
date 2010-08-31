Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0HaXtC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 19:49:02 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47890 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0HaXtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 19:49:01 -0400
Date: Wed, 01 Sep 2010 08:49:10 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 3/3] ARM: Samsung S3C: Move/use the S3C common GPIO IRQ type
In-reply-to: <AANLkTimxhFtfB8G-z=04zj7ZRq+f7GDaVX5mzgCENuvx@mail.gmail.com>
To: "'Kyungmin Park'" <kmpark@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jy0922.shim@samsung.com, m.szyprowski@samsung.com, ben-linux@fluff.org
Message-id: <011701cb4967$1ee563c0$5cb02b40$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=ISO-8859-1
Content-language: ko
Content-transfer-encoding: 8BIT
Thread-index: ActISO2Ft2QM/MpLSDCp+CgHw+Bu7wBGaLbw
References: <20100830114729.GA13150@july>
 <006301cb483c$434f76f0$c9ee64d0$%kim@samsung.com>
 <AANLkTimxhFtfB8G-z=04zj7ZRq+f7GDaVX5mzgCENuvx@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park wrote:
> 
> On Mon, Aug 30, 2010 at 9:09 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > Kyungmin Park wrote:
> >>
> >> From: Kyungmin Park <kyungmin.park@samsung.com>
> >>
> >> Samsung S3C series have the common GPIO IRQ type for all S3C series.
> >>
> > I can't agree with your changing name. Why do you want to change the
name?
> > If you want to move S3C2410_EXTINT_XXX from regs-irqtype.h, just move
> > without any changes.
> As S5P series change the name conversion. I will also modify the s3c
series.
> 
I think that we don’t need to change for it.
And as you see, there is no difference between S3C2410_XXX and S3C_XXX.
> >
> > But I'm still thinking why should we move the external interrupt
definitions
> > to plat/gpio-core.h...
> 
> To use the GPIO interrupt. these definitions are used both external
> interrupt and GPIO interrupt.


> >
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---

(snip)

> >>
> >> +#define S3C_GPIO_LEVEL_LOW           (0x00)
> >> +#define S3C_GPIO_LEVEL_HIGH          (0x01)
> >> +#define S3C_GPIO_EDGE_FALLING                (0x02)
> >> +#define S3C_GPIO_EDGE_RISING         (0x04)
> >> +#define S3C_GPIO_EDGE_BOTH           (0x06)
> >> +
> > GPIO_LELVEL? GPIO_EDGE?...
> >
> > I think EXTINT_LEVEL_XXX and EXTINT_EDGE_XXX are more clear.
> 
>        case IRQ_TYPE_EDGE_BOTH:
>              newvalue = S3C_GPIO_EDGE_BOTH;
> 
> Don't you it's more clear?
> 
I don't think so, I meant that it is used for external interrupt not gpio.
And it used currently for external interrupt.

So, I said that no need to change it now.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

