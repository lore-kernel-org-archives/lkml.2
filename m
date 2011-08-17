Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1HQNSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:18:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42611 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab1HQNR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:17:58 -0400
MIME-Version: 1.0
In-Reply-To: <1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
	<1772239.ndMLD9ec3r@wuerfel>
	<20110817080327.GD13460@opensource.wolfsonmicro.com>
	<201108171242.24918.arnd@arndb.de>
	<1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
Date: Wed, 17 Aug 2011 15:17:57 +0200
Message-ID: <CACRpkdbSVF1FxpuocoXkDFH3vDQc4OoTwjU+9iqj0=vVs3R3dQ@mail.gmail.com>
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kenneth Heitke <kheitke@codeaurora.org>,
        sdharia@codeaurora.org, David Brown <davidb@codeaurora.org>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 3:04 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> The device driver will know what power supplies and other signals the
> device has, and it will know how and when to use them. (...)

And I guess there is nothing in the spec claiming that all devices
be powered-on when you boot?

In that case the devices living on that bus will not respond to
discovery messages until they are powered on, will they?

Or is there some ingenious self-powered shift register
logic doing these responses?

Yours,
Linus Walleij
