Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab1HRDA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 23:00:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43849 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754195Ab1HRDAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 23:00:22 -0400
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kenneth Heitke <kheitke@codeaurora.org>,
        sdharia@codeaurora.org, David Brown <davidb@codeaurora.org>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CACRpkdbSVF1FxpuocoXkDFH3vDQc4OoTwjU+9iqj0=vVs3R3dQ@mail.gmail.com>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
	 <1772239.ndMLD9ec3r@wuerfel>
	 <20110817080327.GD13460@opensource.wolfsonmicro.com>
	 <201108171242.24918.arnd@arndb.de>
	 <1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
	 <CACRpkdbSVF1FxpuocoXkDFH3vDQc4OoTwjU+9iqj0=vVs3R3dQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Wolfson Microelectronics
Date: Thu, 18 Aug 2011 12:00:07 +0900
Message-ID: <1313636407.19990.102.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 15:17 +0200, Linus Walleij wrote:
> On Wed, Aug 17, 2011 at 3:04 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:

> > The device driver will know what power supplies and other signals the
> > device has, and it will know how and when to use them. (...)

> And I guess there is nothing in the spec claiming that all devices
> be powered-on when you boot?

I don't believe so, and if there were I'd not expect anyone to pay a
blind bit of notice to it. 

> In that case the devices living on that bus will not respond to
> discovery messages until they are powered on, will they?

> Or is there some ingenious self-powered shift register
> logic doing these responses?

If my memory serves (I don't have access to the relevant documents right
now) the device announces itself when it detects that the bus is alive.
Slimbus is a relatively heavyweight interface so the extra cost of doing
this won't be too bad.

