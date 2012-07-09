Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab2GIUVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:21:37 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50056 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2GIUVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:21:35 -0400
MIME-Version: 1.0
In-Reply-To: <1341577958-8521-1-git-send-email-lee.jones@linaro.org>
References: <1341577958-8521-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 9 Jul 2012 22:21:34 +0200
Message-ID: <CACRpkdboCpR0wC+KffKPhV3MUG3CSh56WxjqKNPPtTJKp7KY9w@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Pass PMU platform data due for Perf though AUXDATA
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 2:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> When booting with Device Tree we need a way to call-back to the
> DB8500 PMU IRQ handler. This is necessary because the two CPU
> IRQ lines are muxed together on the DB8500 chip. The DB8500
> PMU IRQ handler contains logic to pass over to the other core
> in the case of IRQ_NONE. This patch allows the DB8500 PMU IRQ
> handler to be passed to Perf through platform data.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Makes perfect sense.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
