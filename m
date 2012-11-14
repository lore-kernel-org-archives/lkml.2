Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422865Ab2KNNSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:18:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39026 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab2KNNSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:18:12 -0500
Date: Wed, 14 Nov 2012 13:18:06 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
Message-ID: <20121114131806.GA17338@gmail.com>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
 <1351089926-32161-3-git-send-email-lee.jones@linaro.org>
 <CACRpkda2NQok7kzh0pFmZPYd4nky1kUw=67DZAYAJAXGuc1yzQ@mail.gmail.com>
 <CACRpkdbNWE6hOdVFPxHv7MVHkZUBW3LC035CxJkZVmr8j05Kqw@mail.gmail.com>
 <20121025155143.GK4008@gmail.com>
 <CACRpkdbkcgE-qwuGgOvK9jGTj-0qy3eTFLsN3LYe1G17LmHk9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbkcgE-qwuGgOvK9jGTj-0qy3eTFLsN3LYe1G17LmHk9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Linus Walleij wrote:

> On Thu, Oct 25, 2012 at 5:51 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Thu, 25 Oct 2012, Linus Walleij wrote:
> 
> >> Probably some driver is needing a clk_get() or a clk_get_sys() is
> >> needs to be added somewhere to bring up some vital cluster,
> >> or there may be some out-of-tree driver needed to bring up the
> >> cluster properly I have no clue... Maybe some cluster just
> >> cannot be declocked like that.
> >
> > I leave work in 10 mins and won't be coding again for ~2.5 weeks.
> > So if this is something you could squeeze in and fix-up, I'd be
> > very grateful.
> 
> I'll try. It doesn't look right that a clk_prepare() in the pinctrl
> driver is saving the day for somebody else...

Hi Linus,

Did you apply this in the end?

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
