Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2FWMwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 08:52:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55006 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2FWMw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 08:52:26 -0400
MIME-Version: 1.0
In-Reply-To: <1340338452-885-1-git-send-email-steveb@workware.net.au>
References: <1340338452-885-1-git-send-email-steveb@workware.net.au>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 23 Jun 2012 20:52:04 +0800
Message-ID: <CAMPhdO8TVi720Lm267pDe=aT1Ru8iQAC0Y=d+v7A3Lku9nQ3fA@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: pxa25x_udc: compile fix
To: Steve Bennett <steveb@workware.net.au>
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 12:14 PM, Steve Bennett <steveb@workware.net.au> wrote:
> Signed-off-by: Steve Bennett <steveb@workware.net.au>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/usb/gadget/pxa25x_udc.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/gadget/pxa25x_udc.h b/drivers/usb/gadget/pxa25x_udc.h
> index 861f4df..2eca1e7 100644
> --- a/drivers/usb/gadget/pxa25x_udc.h
> +++ b/drivers/usb/gadget/pxa25x_udc.h
> @@ -225,7 +225,7 @@ dump_state(struct pxa25x_udc *dev)
>                dev->stats.read.bytes, dev->stats.read.ops);
>
>        for (i = 1; i < PXA_UDC_NUM_ENDPOINTS; i++) {
> -               if (dev->ep [i].desc == NULL)
> +               if (dev->ep[i].ep.desc == NULL)
>                        continue;
>                DMSG ("udccs%d = %02x\n", i, *dev->ep->reg_udccs);
>        }
> --
> 1.7.10
>
