Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab2HUQmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:42:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34775 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab2HUQmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:42:50 -0400
Date: Tue, 21 Aug 2012 09:42:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 8/8] input: ab8500-ponkey: Rely on MFD core to convert
 IRQs to virtual
Message-ID: <20120821164244.GA4672@core.coreip.homeip.net>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
 <1344527635-6163-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ-HOGy_sdsCQSNOdYTDzHFszk0OySM88TjO-neSJUz0A@mail.gmail.com>
 <20120821092328.GC26899@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821092328.GC26899@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 10:23:29AM +0100, Lee Jones wrote:
> On Tue, Aug 14, 2012 at 10:31:08AM +0200, Linus Walleij wrote:
> > On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > 
> > > There was a plan to place ab8500_irq_get_virq() calls in each AB8500
> > > child device prior to requesting an IRQ, but as we're no longer using
> > > Device Tree to collect our IRQ numbers, it's actually better to allow
> > > the core to do this during device registration time. So the IRQ number
> > > we pull from its resource has already been converted to a virtual IRQ.
> > >
> > > CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > CC: linux-input@vger.kernel.org
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > This is looking good, I guess you need all patches to go in at the
> > same time so Dmitry's ACK is required.
> 
> Yep, just waiting for that now.

Sorry for the delay. Yes, this shoudl be fine, but since it is
essentially a revert of the original patch it should be pushed in as
such.

Thanks.

-- 
Dmitry
