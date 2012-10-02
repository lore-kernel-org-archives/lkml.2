Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2JBIze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:55:34 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54992 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2JBIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:55:32 -0400
MIME-Version: 1.0
In-Reply-To: <1349165603-24401-2-git-send-email-lee.jones@linaro.org>
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
	<1349165603-24401-2-git-send-email-lee.jones@linaro.org>
Date: Tue, 2 Oct 2012 10:55:30 +0200
Message-ID: <CACRpkdbU-LyzHj9egNeGEaKShdT13QE3b4635tjEuPFfUOMCgg@mail.gmail.com>
Subject: Re: [PATCH 01/10] ARM: ux500: Move all Device Tree booting into cpu-db8500
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 10:13 AM, Lee Jones <lee.jones@linaro.org> wrote:

> To aid the kernel in its effort to move to DT only booting, we're
> transplanting all Device Tree related code to cpu-db8500 which will
> remain persistent throughout the transition. This change paths the
> way for complete removal of board-mop500, which will be done once
> the all DMA settings are moved into the respective DT source files.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looks good:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
