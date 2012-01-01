Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2AAOOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 09:14:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48519 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2AAOOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 09:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <1324541855-19911-2-git-send-email-haojian.zhuang@marvell.com>
References: <1324541855-19911-1-git-send-email-haojian.zhuang@marvell.com>
	<1324541855-19911-2-git-send-email-haojian.zhuang@marvell.com>
Date: Sun, 1 Jan 2012 15:14:36 +0100
Message-ID: <CACRpkdbYyennCeRO3K4M-ya=svyxYD4Nuc9iQ5zDqWjzoZBQGg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] pinctrl: enable pinmux for mmp series
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 9:17 AM, Haojian Zhuang
<haojian.zhuang@marvell.com> wrote:

> Support PXA168/PXA910/MMP2 pinmux. Now only support function switch.
(...)

>  drivers/pinctrl/Kconfig          |   22 +
>  drivers/pinctrl/Makefile         |    4 +
>  drivers/pinctrl/pinctrl-pxa3xx.c |  244 +++++++++
>  drivers/pinctrl/pinctrl-pxa3xx.h |  264 ++++++++++
>  drivers/pinctrl/pinmux-mmp2.c    |  723 +++++++++++++++++++++++++++
>  drivers/pinctrl/pinmux-pxa168.c  |  652 ++++++++++++++++++++++++
>  drivers/pinctrl/pinmux-pxa910.c  | 1008 ++++++++++++++++++++++++++++++++++++++

As per earlier discussion, all files should be named pinctrl-* not pinmux-*.

Can you respin this quickly? I think it's looking good overall
and seems like a nice merge candidate. Remaining problems
can surely be fixed in-tree.

I am even attempted to merge this as it is and fix the renaming myself,
but prefer not to since I might screw something up.

Yours,
Linus Walleij
