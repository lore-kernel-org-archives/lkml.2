Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab2INId5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:33:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42354 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab2INIdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:33:54 -0400
Date: Fri, 14 Sep 2012 09:33:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 14/19] ARM: ux500: Apply tc3589x's GPIO/IRQ properties to
 HREF's DT
Message-ID: <20120914083346.GF3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-15-git-send-email-lee.jones@linaro.org>
 <CACRpkdareUHDsM9Dhh6oFFQ0xgk1n+R--zbGB8wDzWfqUQU8Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdareUHDsM9Dhh6oFFQ0xgk1n+R--zbGB8wDzWfqUQU8Nw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:58:41AM -0700, Linus Walleij wrote:
> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > This patch ensures the tc3589x and tc3598x-gpio devices are
> > rightfully given interrupt controller status. We also describe
> > the tc3598x-gpio GPIO expander in full and specify it as a GPIO
> > controller. Finally we reference that the external MMC slot's
> > Card Detection GPIO on the HREF is located on the tc3598x-gpio
> > expander.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> This should come after the enablement patches instead of
> before them, right? (Or be merged into them even as
> we've discussed.)

No, it needs to come before, or else the legacy values will
be used which aren't correct.

> Apart from that it looks good,
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Yours,
> Linus Walleij

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
