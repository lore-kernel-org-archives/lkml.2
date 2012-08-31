Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2HaXOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:14:12 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63296 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab2HaXOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:14:11 -0400
MIME-Version: 1.0
In-Reply-To: <1346349837-10521-1-git-send-email-m-karicheri2@ti.com>
References: <1346349837-10521-1-git-send-email-m-karicheri2@ti.com>
Date: Sat, 1 Sep 2012 01:14:09 +0200
Message-ID: <CACRpkdZ_jN6SmuzGnKeopHbohHn9bK8tRgrMKBVLatfJDBKsqw@mail.gmail.com>
Subject: Re: [PATCH] gpio:clk: preparation for switch to common clock framework
From: Linus Walleij <linus.walleij@linaro.org>
To: Murali Karicheri <m-karicheri2@ti.com>, Kevin Hilman <khilman@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        mturquette@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 8:03 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:

> As a first step towards migrating davinci platforms to use common clock
> framework, replace all instances of clk_enable() with clk_prepare_enable()
> and clk_disable() with clk_disable_unprepare(). Until the platform is
> switched to use the CONFIG_HAVE_CLK_PREPARE Kconfig variable, this just
> adds a might_sleep() call and would work without any issues.
>
> This will make it easy later to switch to common clk based implementation
> of clk driver from DaVinci specific driver.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

OK the patch is so obviously correct so I just applied it, DaVinci folks,
scream if you still don't want it for some reason...

Yours,
Linus Walleij
