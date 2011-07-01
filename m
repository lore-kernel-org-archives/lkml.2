Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1GAAzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 20:55:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49529 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab1GAAzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 20:55:53 -0400
MIME-Version: 1.0
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F383BB1705@AUSP01VMBX24.collaborationhost.net>
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de>
 <1309430517-23821-2-git-send-email-s.hauer@pengutronix.de>
 <BANLkTikQGFA7XcuAtEEi7_4m-j6-00sZ6Q@mail.gmail.com> <201106301441.24493.arnd@arndb.de>
 <BANLkTin_htv2z3D9Bbf6N8Y7UKFRvPtvOg@mail.gmail.com> <20110630170229.GP6069@pengutronix.de>
 <4E0D0595.5070205@gmail.com> <ADE657CA350FB648AAC2C43247A983F001F383BB1705@AUSP01VMBX24.collaborationhost.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 30 Jun 2011 20:55:33 -0400
Message-ID: <BANLkTin4Sbz=c7V9gu4Qfm3OzZCCpGxOjQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Bill Gatliff <bgat@billgatliff.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ryan Mallon <ryan@bluewatersys.com>, Shawn Guo <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 20:33, H Hartley Sweeten wrote:
> On Thursday, June 30, 2011 4:24 PM, Ryan Mallon wrote:
>> On 01/07/11 03:02, Sascha Hauer wrote:
>>> I think that you made the fundamental mistake to completly ignore the
>>> existing pwm API and its users. With a competing api we are basically
>>> stuck. We can't convert the existing hardware drivers to the new API
>>> because leds-pwm.c, pwm_bl.c and others still depend on the old API and
>>> boards using it would break.
>>
>> I don't think this is really a blocker to Bill's patches. There are
>> three (that I can see) pwm users currently:
>> drivers/video/backlight/pwm_bl.c
>> drivers/leds/leds-pwm.c
>> drivers/input/misc/pwm-beeper.c
>>
>> All of those drivers are trivial and good easily be updated to work with
>> Bill's patches. Bill already provided a leds-pwm driver.
>
> I agree with Ryan.  The three drivers listed above appear to be the only
> pwm "user" drivers.  They are all trivial and could be updated easily.

indeed ... the current pwm API is almost toy like in its simplicity.

> The "core" drivers using the existing API appear to be:
> arch/blackfin/kernel/pwm.c

i only wrote this because Bill's subsystem wasnt yet merged.  but i
made sure that it was done in such a way that it's trivial to convert
over to Bill's work once it's done.
-mike
