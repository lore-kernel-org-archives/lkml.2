Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0HPMWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:22:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60905 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0HPMWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=k8vdgUbmysxdHkMenHi+pqfkxFfLOSSd/OSv3/Wyz0qo6tZek8enYmUo2IjRuHY03l
         ucbOfloTUuSz7i8YzZ+hiaeQdGjY0ZI09fyYIBfjpUotZ8qxfqYzurKseOXeHXP64HX9
         orjnwR2uGQObCX+X6/EudhbydOyM4t48XBkGI=
MIME-Version: 1.0
In-Reply-To: <1281956870-12463-2-git-send-email-s.hauer@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
	<1281956870-12463-2-git-send-email-s.hauer@pengutronix.de>
Date: Mon, 16 Aug 2010 14:22:16 +0200
Message-ID: <AANLkTi=3OYmuPUnBGimGTiGUbh32KDPyoXubvXJZAR99@mail.gmail.com>
Subject: Re: [PATCH 1/3] dmaengine: add possibility for cyclic transfers
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/16 Sascha Hauer <s.hauer@pengutronix.de>:

> Cyclic transfers are useful for audio where a single buffer divided
> in periods has to be transfered endlessly until stopped. After being
> prepared the transfer is started using the dma_async_descriptor->tx_submit
> function. dma_async_descriptor->callback is called after each period.
> The transfer is stopped using the DMA_TERMINATE_ALL callback.
> While being used for cyclic transfers the channel cannot be used
> for other transfer types.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Looks good to me.
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
