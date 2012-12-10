Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab2LJWaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:30:00 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44167 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2LJW37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:29:59 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: samsung: Add terminating entry for exynos_pinctrl_ids
To: Linus Walleij <linus.walleij@linaro.org>, Axel Lin <axel.lin@ingics.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
In-Reply-To: <CACRpkdY=yoYi71MLC=7iktFMTTQWmk4iLwrKqOnuuJEz43K74g@mail.gmail.com>
References: <1355103317.4166.1.camel@phoenix> <CACRpkdY=yoYi71MLC=7iktFMTTQWmk4iLwrKqOnuuJEz43K74g@mail.gmail.com>
Date: Mon, 10 Dec 2012 22:10:45 +0000
Message-Id: <20121210221045.4EA803E0D9C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012 11:13:06 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Dec 10, 2012 at 2:35 AM, Axel Lin <axel.lin@ingics.com> wrote:
> 
> > The of_device_id table is supposed to be zero-terminated.
> >
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > ---
> >  drivers/gpio/gpio-samsung.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> > index 01f7fe9..9e251be 100644
> > --- a/drivers/gpio/gpio-samsung.c
> > +++ b/drivers/gpio/gpio-samsung.c
> > @@ -3026,6 +3026,7 @@ static __init int samsung_gpiolib_init(void)
> >         static const struct of_device_id exynos_pinctrl_ids[] = {
> >                 { .compatible = "samsung,pinctrl-exynos4210", },
> >                 { .compatible = "samsung,pinctrl-exynos4x12", },
> > +               { }
> 
> Wasn't somebody complaining that this was unnecessary recently?
> 
> Ohwell, I'll let the Samsung people comment first...

And this doesn't apply on my gpio/next branch. I assume it applies
somewhere else so I'll ignore for now. :-)

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.
