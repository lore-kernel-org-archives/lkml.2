Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3AJNi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:38:29 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37653 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3AJNi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:38:27 -0500
Date: Thu, 10 Jan 2013 14:38:18 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] usb: musb: ux500: use clk_prepare_enable and
 clk_disable_unprepare
Message-ID: <20130110133818.GA22710@balto.lan>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Felipe Balbi <balbi@ti.com>, Ulf Hansson <ulf.hansson@linaro.org>,
	linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
References: <1357577261-31536-1-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkdZD1i_tvDf6XFyk5muYjtDziQaMNGK6vvihhFJVztXUjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZD1i_tvDf6XFyk5muYjtDziQaMNGK6vvihhFJVztXUjw@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc2-00036-g5f73896 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Thu, Jan 10, 2013 at 12:23:32PM +0100, Linus Walleij wrote:
> On Mon, Jan 7, 2013 at 5:47 PM, Fabio Baltieri
> <fabio.baltieri@linaro.org> wrote:
> 
> > This patch converts the module to use clk_prepare_enable and
> > clk_disable_unprepare variants as required by common clock framework.
> >
> > Without this the system crash during probe function.
> >
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks for the ACK.  This bug was here unnoticed since 3.6 merge window,
do you think it may make sense to add this driver to u8500_defconfig?  I
can send a patch if you say so...

Thanks,
Fabio

-- 
Fabio Baltieri
