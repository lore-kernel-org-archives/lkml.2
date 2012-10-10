Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2JJHx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 03:53:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33905 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab2JJHx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 03:53:57 -0400
MIME-Version: 1.0
In-Reply-To: <201210091535.56487.arnd@arndb.de>
References: <201210091535.56487.arnd@arndb.de>
Date: Wed, 10 Oct 2012 09:53:55 +0200
Message-ID: <CACRpkdZE9xjKB_+nY263fBefBy7Hsgo7uxTsHs78xbAr3_N-VQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sirf: remove sirfsoc_gpio_set_pull function
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Barry Song <Baohua.Song@csr.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 5:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> The prima2 platform advertises needing no mach/gpio.h header file,
> but its pinctrl driver now has a sirfsoc_gpio_set_pull function
> that uses constants defined in arch/arm/mach-prima2/include/mach/gpio.h,
> which fails to build.

Applied to my pinctrl "fixes" branch with Barry's ACK.

Thanks!
Linus Walleij
