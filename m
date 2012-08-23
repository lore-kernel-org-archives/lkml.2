Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013Ab2HWNcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:32:02 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35431 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933980Ab2HWNb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:31:58 -0400
MIME-Version: 1.0
In-Reply-To: <1345707346-9035-9-git-send-email-linux@prisktech.co.nz>
References: <1345707346-9035-1-git-send-email-linux@prisktech.co.nz>
	<1345707346-9035-9-git-send-email-linux@prisktech.co.nz>
Date: Thu, 23 Aug 2012 15:31:56 +0200
Message-ID: <CACRpkdYsUydqAfvYOKtQw9nBA4TpwF-=Af3kDUwwm6jbuiE68w@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCHv4 8/9] arm: vt8500: gpio: Devicetree support
 for arch-vt8500
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mike Turquette <mturquette@ti.com>,
        Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 9:35 AM, Tony Prisk <linux@prisktech.co.nz> wrote:

> Converted the existing arch-vt8500 gpio to a platform_device.
> Added support for WM8505 and WM8650 GPIO controllers.
> Replaced existing readl/writel calls with _relaxed variants.
> Replaced existing unsigned variables with u32 to match register size.
>
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

Sweet!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
