Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab2ITGet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:34:49 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49483 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2ITGer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:34:47 -0400
MIME-Version: 1.0
In-Reply-To: <1347983548-15243-1-git-send-email-lee.jones@linaro.org>
References: <1347983548-15243-1-git-send-email-lee.jones@linaro.org>
Date: Thu, 20 Sep 2012 08:34:46 +0200
Message-ID: <CACRpkdb3KMMOvyi2kKGXUNH+=8Cy3xNDRa7Ez6aSLgod_8mF9A@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Fix SSP register address format
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 5:52 PM, Lee Jones <lee.jones@linaro.org> wrote:

> SSP won't probe unless the specified register address format
> is correct i.e. we have to specify that the address is in hex.
> After this patch has been applied, the SSP (SPI) driver probes
> as expected.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
