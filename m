Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1HIKHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:07:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55672 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1HIKHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:07:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2V-66Wn7nwJz6tOkESoQAUJzAg-47YeMY0vzwu6T9O=Rg@mail.gmail.com>
References: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
	<20110808081552.GI32513@linux-sh.org>
	<CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
	<CAH9JG2V-66Wn7nwJz6tOkESoQAUJzAg-47YeMY0vzwu6T9O=Rg@mail.gmail.com>
Date: Tue, 9 Aug 2011 12:07:02 +0200
Message-ID: <CACRpkdaoLYiqgR9vyU2ww6WjtW8Pox2uguKyQowj1iSdESV=6w@mail.gmail.com>
Subject: Re: [PATCH] GPIOLIB: add generic gpio_set_pull API
From: Linus Walleij <linus.walleij@linaro.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Paul Mundt <lethal@linux-sh.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 12:57 AM, Kyungmin Park <kmpark@infradead.org> wrote:

> If gpiolib accept the pullup control. gpiolib is better place to
> control gpio config.
> then remains are the gpio driver strength, and power down mode
> control. powerdown pull-up/down, powerdown in/out at samsung gpios.

I agree. And this is what I need to move the U300 and Nomadik
GPIO drivers over to struct gpio_chip.

Yours,
Linus Walleij
