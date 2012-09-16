Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2IPWYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 18:24:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56199 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2IPWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 18:24:14 -0400
MIME-Version: 1.0
In-Reply-To: <1347658492-11608-14-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
	<1347658492-11608-14-git-send-email-arnd@arndb.de>
Date: Mon, 17 Sep 2012 00:24:13 +0200
Message-ID: <CACRpkdYz-U2G6ZbJCbdoAAdEnCWfvDNovD0TyTs0kBdcn+U1Xw@mail.gmail.com>
Subject: Re: [PATCH 13/24] ARM: nomadik: use __iomem pointers for MMIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Alessandro Rubini <rubini@unipv.it>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.
>
> Cc: Alessandro Rubini <rubini@unipv.it>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-nomadik/board-nhk8815.c           |    3 +--
>  arch/arm/mach-nomadik/include/mach/hardware.h   |    2 +-
>  arch/arm/mach-nomadik/include/mach/uncompress.h |    8 ++++----
>  3 files changed, 6 insertions(+), 7 deletions(-)

Looks good to me, thanks!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
