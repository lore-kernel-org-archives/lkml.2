Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab1LEL3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:29:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38523 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab1LEL3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:29:52 -0500
MIME-Version: 1.0
In-Reply-To: <1323083166.6763.3.camel@phoenix>
References: <1323083166.6763.3.camel@phoenix>
Date: Mon, 5 Dec 2011 19:29:51 +0800
Message-ID: <CAN1soZyMxP4qKow+XKk09KAdzdctdzz=aiYbiTqek923xirK0A@mail.gmail.com>
Subject: Re: [PATCH v2] pcmcia: pxa: replace IRQ_GPIO() with gpio_to_irq()
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Ian Molton <spyro@f2s.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-pcmcia@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 7:06 PM, Axel Lin <axel.lin@gmail.com> wrote:
> Since commit 6384fd "ARM: pxa: rename IRQ_GPIO to PXA_GPIO_TO_IRQ",
> I got buid errors due to implicit declaration of function 'IRQ_GPIO'.
>
> Use common gpio_to_irq() to replace machine dependant macro IRQ_GPIO().
>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> Cc: Ian Molton <spyro@f2s.com>
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Zhuang <haojian.zhuang@marvell.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> v2:
> I just found pxa2xx_trizeps4.c also needs to be converted to gpio_to_irq.
> Thus include the fix for pxa2xx_trizeps4.c in v2.
>
>  drivers/pcmcia/pxa2xx_e740.c      |   11 +++++++----
>  drivers/pcmcia/pxa2xx_palmld.c    |    2 +-
>  drivers/pcmcia/pxa2xx_palmtc.c    |    2 +-
>  drivers/pcmcia/pxa2xx_stargate2.c |    6 ++++--
>  drivers/pcmcia/pxa2xx_trizeps4.c  |    5 +++--
>  drivers/pcmcia/pxa2xx_vpac270.c   |    4 ++--
>  6 files changed, 18 insertions(+), 12 deletions(-)
>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
