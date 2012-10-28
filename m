Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2J1TSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:18:11 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59342 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2J1TSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:18:10 -0400
MIME-Version: 1.0
In-Reply-To: <1351181518-11882-2-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
	<1351181518-11882-2-git-send-email-m-karicheri2@ti.com>
Date: Sun, 28 Oct 2012 20:18:08 +0100
Message-ID: <CACRpkdaa8f7N90hknaqZmNeYD1SjQx6Fm35nS34CxwnH+fwEfg@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] clk: davinci - add main PLL clock driver
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

> This is the driver for the main PLL clock hardware found on DM SoCs.
> This driver borrowed code from arch/arm/mach-davinci/clock.c and
> implemented the driver as per common clock provider API. The main PLL
> hardware typically has a multiplier, a pre-divider and a post-divider.
> Some of the SoCs has the divider fixed meaning they can not be
> configured through a register. HAS_PREDIV and HAS_POSTDIV flags are used
> to tell the driver if a hardware has these dividers present or not.
> Driver is configured through the struct clk_pll_data that has the
> SoC specific clock data.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

This looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
