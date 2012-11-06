Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2KFDgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 22:36:22 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33527 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2KFDgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 22:36:21 -0500
MIME-Version: 1.0
In-Reply-To: <1352169260.2625.4.camel@phoenix>
References: <1352169260.2625.4.camel@phoenix>
Date: Tue, 6 Nov 2012 09:06:18 +0530
X-Google-Sender-Auth: 0N3lOuMZR0iI_PAdjqUQRzEEofY
Message-ID: <CAOh2x==ng3A66P=Vx+-C791LTGCS1fWVpMfUKDorU5G=ZXrjLQ@mail.gmail.com>
Subject: Re: [PATCH] clk: spear: Add stub functions for spear3[0|1|2]0_clk_init()
From: viresh kumar <viresh.kumar@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 8:04 AM, Axel Lin <axel.lin@ingics.com> wrote:
> This fixes compile error if one of SPEAr3xx implementations is not selected.
>
>   CC      drivers/clk/spear/spear3xx_clock.o
> drivers/clk/spear/spear3xx_clock.c: In function 'spear3xx_clk_init':
> drivers/clk/spear/spear3xx_clock.c:599:3: error: implicit declaration of function 'spear300_clk_init' [-Werror=implicit-function-declaration]
> drivers/clk/spear/spear3xx_clock.c:601:3: error: implicit declaration of function 'spear310_clk_init' [-Werror=implicit-function-declaration]
> drivers/clk/spear/spear3xx_clock.c:603:3: error: implicit declaration of function 'spear320_clk_init' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/clk/spear/spear3xx_clock.o] Error 1
> make[2]: *** [drivers/clk/spear] Error 2
> make[1]: *** [drivers/clk] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks..
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
