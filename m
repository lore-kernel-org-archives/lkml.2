Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab2INJUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:20:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45386 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758343Ab2INJUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:20:39 -0400
Date: Fri, 14 Sep 2012 10:20:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Ola LILJA2 <ola.o.lilja@stericsson.com>,
        Roger NILSSON1 <roger.xr.nilsson@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: Re: [PATCH 07/19] ARM: ux500: Add all encompassing sound node to the
 HREF Device Tree
Message-ID: <20120914092031.GK3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-8-git-send-email-lee.jones@linaro.org>
 <CACRpkdbh5BFmHp4uurmWfBExUKD0GDJCOHGp8kJCu2tReTWKWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbh5BFmHp4uurmWfBExUKD0GDJCOHGp8kJCu2tReTWKWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 02:56:20AM -0700, Linus Walleij wrote:
> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > This is where we link together all of the SoC sound components for
> > a given platform. This all encompassing sound node is only found
> > in the very lowest hierarchical DTS file, since the component mix may
> > well change from board variant to board variant.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/hrefv60plus.dts |    7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
> > index 4f0aee8..d8ed29e 100644
> > --- a/arch/arm/boot/dts/hrefv60plus.dts
> > +++ b/arch/arm/boot/dts/hrefv60plus.dts
> > @@ -78,6 +78,13 @@
> >                         status = "okay";
> >                 };
> >
> > +               sound {
> > +                       compatible = "stericsson,snd-soc-mop500";
> > +
> > +                       stericsson,cpu-dai = <&msp1 &msp3>;
> > +                       stericsson,audio-codec = <&codec>;
> 
> Where is this codec coming from?
> 
> It's certainly not in the linux-next tree...

No, I'm holding it locally.

My Audio patch-set is still awaiting Ola's Acks (6 patches)

... unless they're further down my mailbox.

/me keeps reading.

> This is another of these patches that I prefer if Ola
> or Roger or even Mark could comment on, I really don't know
> too much about ASoC DT bindings...



-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
