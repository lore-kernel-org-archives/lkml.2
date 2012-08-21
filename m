Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2HUJXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:23:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61655 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab2HUJXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:23:34 -0400
Date: Tue, 21 Aug 2012 10:23:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 8/8] input: ab8500-ponkey: Rely on MFD core to convert
 IRQs to virtual
Message-ID: <20120821092328.GC26899@gmail.com>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
 <1344527635-6163-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ-HOGy_sdsCQSNOdYTDzHFszk0OySM88TjO-neSJUz0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZ-HOGy_sdsCQSNOdYTDzHFszk0OySM88TjO-neSJUz0A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 10:31:08AM +0200, Linus Walleij wrote:
> On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > There was a plan to place ab8500_irq_get_virq() calls in each AB8500
> > child device prior to requesting an IRQ, but as we're no longer using
> > Device Tree to collect our IRQ numbers, it's actually better to allow
> > the core to do this during device registration time. So the IRQ number
> > we pull from its resource has already been converted to a virtual IRQ.
> >
> > CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > CC: linux-input@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> This is looking good, I guess you need all patches to go in at the
> same time so Dmitry's ACK is required.

Yep, just waiting for that now.
 
> FWIW:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> BTW: this makes me suspect that the public ab8500_irq_get_virq()
> interface can be *deleted* and the function made static in the
> AB8500 driver, right?

Right. Already taken care of.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
