Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab2J1T0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:26:03 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:50001 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2J1T0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:26:00 -0400
MIME-Version: 1.0
In-Reply-To: <1351181518-11882-4-git-send-email-m-karicheri2@ti.com>
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com>
	<1351181518-11882-4-git-send-email-m-karicheri2@ti.com>
Date: Sun, 28 Oct 2012 20:25:58 +0100
Message-ID: <CACRpkdZeor=V624OvBek1FccWFvYr2=mPBXZat8ELTtNTTL_rw@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] clk: davinci - common clk utilities to init clk driver
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

> This is the common clk driver initialization functions for DaVinci
> SoCs and other SoCs that uses similar hardware architecture.
> clock.h also defines struct types for clock definitions in a SoC
> and clock data type for configuring clk-mux. The initialization
> functions are used by clock initialization code in a specific
> platform/SoC.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

This is looking good.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
