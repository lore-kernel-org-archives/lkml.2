Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1HIKLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:11:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46167 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1HIKLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:11:52 -0400
MIME-Version: 1.0
In-Reply-To: <4E40912C.5040801@codeaurora.org>
References: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
	<20110808081552.GI32513@linux-sh.org>
	<CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
	<CAH9JG2V-66Wn7nwJz6tOkESoQAUJzAg-47YeMY0vzwu6T9O=Rg@mail.gmail.com>
	<4E40912C.5040801@codeaurora.org>
Date: Tue, 9 Aug 2011 12:11:51 +0200
Message-ID: <CACRpkdZUxYP0Mbe+heEwrZE5VC+J42g_-QAusrOsUuBPT324Hw@mail.gmail.com>
Subject: Re: [PATCH] GPIOLIB: add generic gpio_set_pull API
From: Linus Walleij <linus.walleij@linaro.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 3:45 AM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:

> If we add this API - the remaining gpio controls like drive strength and
> function select could also be added,

I agree.

> which eats into the pinmux domain.

That's not so bad, since the pinctrl/pinmux subsystem is just a prototype
people may want to wrap up their drivers into gpio_chip/gpiolib as
they stand today to atleast get some isolation. Later on they can
refactor and migrate to a pinctrl/pinmux subsystem.

The latter will take some time to provide anyway, since I have been
asked to restructure it so as not to use a global pin number space.

> Linus W. had a patch earlier which added an API for a gpio config to be
> specified through gpiolib. " gpio: add a custom configuration mechanism to
> gpiolib" which is sort of an extensible model of this API.

Yes I think I have already suggested a bunch of ways to skin this
cat but somehow none of them seem to win general approval.

Yours,
Linus Walleij
