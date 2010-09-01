Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab0IAAgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 20:36:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11890 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab0IAAgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 20:36:31 -0400
Date: Wed, 01 Sep 2010 09:36:41 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 1/3] ARM: Samsung S5P: Move the common Samsung S5P series
 GPIO level type
In-reply-to: <AANLkTinYiG2y=x48kkV=XMzpsc_a677Xsox6dNkuHMF3@mail.gmail.com>
To: "'Kyungmin Park'" <kmpark@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jy0922.shim@samsung.com, m.szyprowski@samsung.com, ben-linux@fluff.org
Message-id: <011e01cb496d$c1e40440$45ac0cc0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=ISO-8859-1
Content-language: ko
Content-transfer-encoding: 8BIT
Thread-index: ActISDchUNFxjRXNSiKYMrVq5vT3AQBGkfjA
References: <20100830114708.GA13140@july>
 <006201cb483b$0e1727e0$2a4577a0$%kim@samsung.com>
 <AANLkTinYiG2y=x48kkV=XMzpsc_a677Xsox6dNkuHMF3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park wrote:
> 
> On Mon, Aug 30, 2010 at 9:01 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> > Kyungmin Park wrote:
> >>
> >> From: Kyungmin Park <kyungmin.park@samsung.com>
> >>
> >> Samsung S5P series has common level type. It's different from S3C
series.
> >>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >>  arch/arm/plat-samsung/include/plat/gpio-core.h |    6 ++++++
> >>  1 files changed, 6 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/arm/plat-samsung/include/plat/gpio-core.h
> > b/arch/arm/plat-
> >> samsung/include/plat/gpio-core.h
> >> index e358c7d..c8681e0 100644
> >> --- a/arch/arm/plat-samsung/include/plat/gpio-core.h
> >> +++ b/arch/arm/plat-samsung/include/plat/gpio-core.h
> >> @@ -14,6 +14,12 @@
> >>  #define GPIOCON_OFF  (0x00)
> >>  #define GPIODAT_OFF  (0x04)
> >>
> >> +#define S5P_GPIO_LEVEL_LOW           (0x00)
> >> +#define S5P_GPIO_LEVEL_HIGH          (0x01)
> >> +#define S5P_GPIO_EDGE_FALLING                (0x02)
> >> +#define S5P_GPIO_EDGE_RISING         (0x03)
> >> +#define S5P_GPIO_EDGE_BOTH           (0x04)
> >
> > Why should we change the name of definition from S5P_EXTINT_XXX?
> > If we use that, we don't need to change other files.
> 
> External interrupt is one of GPIOs. and it's used for GPIO interrupt.
> Do you want to use the EXTINT at generic gpio function?
> 
Right, it is one of the GPIO pin's usage.
But it doesn't mean that should be used like/with generic GPIO...
Even though the value of their polarity is same.

Anyway,...let's think about that again.

> Also change the name format as IRQ_TYPE_* style.
> 
(snip)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

