Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab2GIUh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:37:27 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58305 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2GIUhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:37:25 -0400
MIME-Version: 1.0
In-Reply-To: <4FFB40A4.5060505@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<4FF6994B.9040801@linaro.org>
	<20120706173957.GA10202@core.coreip.homeip.net>
	<4FFB288D.4080606@linaro.org>
	<20120709201422.GA12242@core.coreip.homeip.net>
	<4FFB40A4.5060505@linaro.org>
Date: Mon, 9 Jul 2012 22:37:25 +0200
Message-ID: <CACRpkdbB68mXuV3bx-gyJBdJCd2Ja86J8mvvmR3ez3dJ8SzOEg@mail.gmail.com>
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 10:35 PM, Lee Jones <lee.jones@linaro.org> wrote:

> From: Lee Jones <lee.jones@linaro.org>
> Date: Tue, 26 Jun 2012 10:46:50 +0100
> Subject: [PATCH 1/1] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping
>
> Before we can use any domain allocated IRQ, we need to first create a
> map between the Hardware IRQ (hwirq) and the Linux Virtual IRQ (virq).
> We do this with a helper function provided by the AB8500 IRQ domain
> controller called ab8500_irq_get_virq(). We need to do this for both
> IRQs which the Power-On-Key driver uses; one for button press, the other
> for button depress.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
