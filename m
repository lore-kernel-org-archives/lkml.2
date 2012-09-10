Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab2IJM6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:58:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59005 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab2IJM6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:58:42 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-15-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-15-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 05:58:41 -0700
Message-ID: <CACRpkdareUHDsM9Dhh6oFFQ0xgk1n+R--zbGB8wDzWfqUQU8Nw@mail.gmail.com>
Subject: Re: [PATCH 14/19] ARM: ux500: Apply tc3589x's GPIO/IRQ properties to
 HREF's DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch ensures the tc3589x and tc3598x-gpio devices are
> rightfully given interrupt controller status. We also describe
> the tc3598x-gpio GPIO expander in full and specify it as a GPIO
> controller. Finally we reference that the external MMC slot's
> Card Detection GPIO on the HREF is located on the tc3598x-gpio
> expander.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This should come after the enablement patches instead of
before them, right? (Or be merged into them even as
we've discussed.)

Apart from that it looks good,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
