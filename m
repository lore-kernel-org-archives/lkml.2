Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab2IPWTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 18:19:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36821 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2IPWTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 18:19:13 -0400
MIME-Version: 1.0
In-Reply-To: <1347658492-11608-7-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
	<1347658492-11608-7-git-send-email-arnd@arndb.de>
Date: Mon, 17 Sep 2012 00:19:11 +0200
Message-ID: <CACRpkdYsv7LJj=aJj3y-GhpAMD8PTKdLsYO8KATWevMM4F5MaQ@mail.gmail.com>
Subject: Re: [PATCH 06/24] ARM: integrator: use __iomem pointers for MMIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.
>
> This patch has a few small conflicts with stuff in linux-next, which
> we have to sort out in arm-soc.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

However if Russell applies some of the stuff that is pending
in his tracker (was pending uncertain acceptance of
CONFIG_ATAGS, which is merged now) this will likely
conflict.

Yours,
Linus Walleij
