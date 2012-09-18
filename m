Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2IRMDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:03:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64617 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab2IRMD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:03:29 -0400
MIME-Version: 1.0
In-Reply-To: <1347901159-3665-1-git-send-email-stigge@antcom.de>
References: <1347901159-3665-1-git-send-email-stigge@antcom.de>
Date: Tue, 18 Sep 2012 14:03:28 +0200
Message-ID: <CACRpkdbRQsLWT=xocPTQnLVU34MGSX6XgZ+-f3w-hOetzwnbuw@mail.gmail.com>
Subject: Re: [PATCH] spi/pl022: Devicetree support w/o platform data
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: lee.jones@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 6:59 PM, Roland Stigge <stigge@antcom.de> wrote:

> Even with devicetree support, we needed platform data to provide some data like
> bus_id and enable_dma, leading to mixed device tree and platform data. This
> patch makes it possible to provide all that information via device tree. Now,
> the data must be provided via platform data _or_ device tree completely.
>
> Only in case of callback specification (dma_filter()), platform data is
> necessary.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

This looks good so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

But I think you need to page Mark Brown so it
gets picked to the stuff queued for the next merge window.
I think the dependent patch is in his SPI tree.

So I'd resend it to mark+grant with my ACK.

Yours,
Linus Walleij
