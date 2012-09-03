Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab2ICL3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:29:24 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:47808 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756303Ab2ICL3X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:29:23 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 3 Sep 2012 13:28:44 +0200
Subject: RE: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
Thread-Topic: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
Thread-Index: Ac2JxLfOVW5eTaysTgSFLj6TxJpOZwAAPhuw
Message-ID: <F45880696056844FA6A73F415B568C695B0EA11A90@EXDCVYMBSTM006.EQ1STM.local>
References: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdakZMWnk1zzFqa8SXLsDn9EaSxzKnH_yXoCaxCY5saVJQ@mail.gmail.com>
In-Reply-To: <CACRpkdakZMWnk1zzFqa8SXLsDn9EaSxzKnH_yXoCaxCY5saVJQ@mail.gmail.com>
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

> On Sun, Sep 2, 2012 at 12:30 PM, Thierry Reding <thierry.reding@avionic-
> design.de> wrote:
> 
> > This commit moves the driver to drivers/pwm and converts it to the new
> > PWM framework.
> >
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> > Note: I'll take this through the PWM tree, but I'd like to have it
> > acknowledged by a few people who know the hardware and can actually
> > test whether this still works.
> 
> Pls include Arun on these patches, he'll know best if it'll work or not.
> 
> I have one generic question: will this alter the layout of sysfs so we need to
> change userspace? I had such issues before when moving drivers to new
> busses...
> 

Since this pwm framework is still a set of exported functions in a header file,
the file architecture doesn't really matter. 
Using this driver, either leds-pwm and backlight-pwm is used to register and
this is where actual registration happens(sysfs entry is created).

Thanks and Regards,
Arun R Murthy
------------------
