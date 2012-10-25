Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab2JYNHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:07:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39982 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab2JYNHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:07:21 -0400
Date: Thu, 25 Oct 2012 14:07:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
Message-ID: <20121025130715.GG4008@gmail.com>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
 <1351089926-32161-3-git-send-email-lee.jones@linaro.org>
 <CACRpkda2NQok7kzh0pFmZPYd4nky1kUw=67DZAYAJAXGuc1yzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkda2NQok7kzh0pFmZPYd4nky1kUw=67DZAYAJAXGuc1yzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Linus Walleij wrote:

> On Wed, Oct 24, 2012 at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The clock framework has changed somewhat and it's now better to
> > invoke clock_prepare_enable() and clk_disable_unprepare() rather
> > than the legacy clk_enable() and clk_disable() calls. This patch
> > converts the Nomadik Pin Control driver to the new framework.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> I was convinced that this is a good change but no regression,
> so applied to the devel branch for 3.8.
> 
> I also removed the initial clk_prepare() so the reference count
> may actually go down to 0 for the GPIO block and the peripheral
> cluster eventually gets relaxed.

Nice. Thanks Linus.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
