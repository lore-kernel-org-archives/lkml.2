Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab2J3Wxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:53:41 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47060 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab2J3Wxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:53:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Date: Tue, 30 Oct 2012 23:57:41 +0100
Message-ID: <2288906.HJczx1g3gj@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CACRpkdac=ztY0vXQ8Mu6H8fiAO4aFSSF-A6O1Q==zKOKEsJegw@mail.gmail.com>
References: <20121025205901.GA3827@sirena.org.uk> <20121030183704.GX4511@opensource.wolfsonmicro.com> <CACRpkdac=ztY0vXQ8Mu6H8fiAO4aFSSF-A6O1Q==zKOKEsJegw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 30, 2012 10:51:11 PM Linus Walleij wrote:
> On Tue, Oct 30, 2012 at 7:37 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > More seriously the amount of time we seem to have been spending recently
> > on changes which end up requiring us to go through essentially every
> > driver and add code to them (often several times) doesn't seem like
> > we're doing a good job here.
> 
> If this is your main concern you should be made aware that there
> are people out there planning to supplant the existing DT probe paths
> that are now being added to each and every ARM-related driver
> with an ACPI probe path as ARM servers come into the picture.

That's correct.

> > pinctrl is really noticable because it's
> > new but it's not the only thing.  As a subsystem maintainer this code
> > just makes me want to add new subsystem features to pull the code out of
> > drivers but obviously that's not something that should be being done at
> > the subsystem level.
> 
> We did manage to drag the power/voltage domain per se out
> of the AMBA bus, and recommend that people (like us) do that
> business using the power domains.
> 
> I think most people (including OMAP) have bought
> into the concept of using the runtime PM framework and power
> domains to control the power domain switches.
> 
> It's this wider concept of using the loose concept "PM resource
> domains" to control also clocks and pins that is at stake, and so
> far the runtime PM core people (Rafael and Magnus) has not said
> much so I think we need some kind of indication from them as to
> what is to happen, long-term, with drivers handling their own clocks
> and pins. Should it be centralized or not? If it's to be centralized it
> needs to become a large piece of infrastructure refactoring and
> needs the attention of Linaro and the like to happen.

Well, I personally think it should be centralized somehow.  I'm not quite
sure how to achieve that, though.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
