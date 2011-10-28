Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab1J1UDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:03:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59524 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab1J1UDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:03:35 -0400
MIME-Version: 1.0
In-Reply-To: <1319773104-3541-1-git-send-email-Barry.Song@csr.com>
References: <1319773104-3541-1-git-send-email-Barry.Song@csr.com>
Date: Fri, 28 Oct 2011 22:03:34 +0200
Message-ID: <CACRpkdaG_J1pKhzsfbjAEv6AQ_V0q6w=VTyxf6ur5aQdAnK34A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Fix "warning: 'struct pinctrl_dev' declared
 inside parameter list"
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <Barry.Song@csr.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        workgroup.linux@csr.com, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 5:38 AM, Barry Song <Barry.Song@csr.com> wrote:

> From: Barry Song <Baohua.Song@csr.com>
>
> when pinctl subsystem is not selected, when compiling drivers including
> the include/linux/pinctrl/pinctrl.h, we will get the warning as below:
> In file included from include/linux/pinctrl/pinmux.h:17,
>                 from drivers/tty/serial/sirfsoc_uart.c:25:
> include/linux/pinctrl/pinctrl.h:126: warning: 'struct pinctrl_dev'
>                declared inside parameter list
> include/linux/pinctrl/pinctrl.h:126: warning: its scope is only this
>      definition or declaration, which is probably not what you want
>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>

OK applied.

Thanks,
Linus Walleij
