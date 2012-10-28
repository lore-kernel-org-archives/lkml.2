Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab2J1T07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:26:59 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39248 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2J1T06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:26:58 -0400
MIME-Version: 1.0
In-Reply-To: <1351181518-11882-5-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
	<1351181518-11882-5-git-send-email-m-karicheri2@ti.com>
Date: Sun, 28 Oct 2012 20:26:57 +0100
Message-ID: <CACRpkdY3ji_twCqej6Yf8grR7oovf3jeGrbQMzybk5CK5f2Y9A@mail.gmail.com>
Subject: Re: [PATCH v3 04/11] clk: davinci - add pll divider clock driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: mturquette@linaro.org, arnd@arndb.de, akpm@linux-foundation.org,
        shawn.guo@linaro.org, rob.herring@calxeda.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, nsekhar@ti.com, khilman@ti.com,
        linux@arm.linux.org.uk, sshtylyov@mvista.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-keystone@list.ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 6:11 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:

> pll dividers are present in the pll controller of DaVinci and Other
> SoCs that re-uses the same hardware IP. This has a enable bit for
> bypass the divider or enable the driver. This is a sub class of the
> clk-divider clock checks the enable bit to calculare the rate and
> invoke the recalculate() function of the clk-divider if enabled.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Looking good,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
