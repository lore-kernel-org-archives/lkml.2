Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab2IQFBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 01:01:33 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:45209 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553Ab2IQFBb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 01:01:31 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 17 Sep 2012 07:01:16 +0200
Subject: RE: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
Thread-Topic: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
Thread-Index: Ac2RxBmYXA2DCNCMS8eImB9KzeHEGACzDa1Q
Message-ID: <F45880696056844FA6A73F415B568C695B44A603C3@EXDCVYMBSTM006.EQ1STM.local>
References: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdakZMWnk1zzFqa8SXLsDn9EaSxzKnH_yXoCaxCY5saVJQ@mail.gmail.com>
 <F45880696056844FA6A73F415B568C695B0EA11A90@EXDCVYMBSTM006.EQ1STM.local>
 <20120907132209.GG29340@avionic-0098.mockup.avionic-design.de>
 <20120913152558.GA19478@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120913152558.GA19478@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Sep 07, 2012 at 03:22:09PM +0200, Thierry Reding wrote:
> > On Mon, Sep 03, 2012 at 01:28:44PM +0200, Arun MURTHY wrote:
> > > > On Sun, Sep 2, 2012 at 12:30 PM, Thierry Reding
> > > > <thierry.reding@avionic- design.de> wrote:
> > > >
> > > > > This commit moves the driver to drivers/pwm and converts it to
> > > > > the new PWM framework.
> > > > >
> > > > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > > > ---
> > > > > Note: I'll take this through the PWM tree, but I'd like to have
> > > > > it acknowledged by a few people who know the hardware and can
> > > > > actually test whether this still works.
> > > >
> > > > Pls include Arun on these patches, he'll know best if it'll work or not.
> > > >
> > > > I have one generic question: will this alter the layout of sysfs
> > > > so we need to change userspace? I had such issues before when
> > > > moving drivers to new busses...
> > > >
> > >
> > > Since this pwm framework is still a set of exported functions in a
> > > header file, the file architecture doesn't really matter.
> > > Using this driver, either leds-pwm and backlight-pwm is used to
> > > register and this is where actual registration happens(sysfs entry is
> created).
> >
> > Hi Arun,
> >
> > Have you been able to verify, then, that the driver still works after
> > this patch? Can I add your Acked-by as well?
> 
> Hi Arun,
> 
> any news on this?
> 
> Thierry

Hi Thierry,
	Works with certain changes in platform data which I can manage
to push it later.

Acked-by: Arun Murthy<arun.murthy@stericsson.com>
	
Thanks and Regards,
Arun R Murthy
------------------
