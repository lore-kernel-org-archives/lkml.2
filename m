Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2CLQcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:32:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47475 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab2CLQcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:32:16 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] Documentation/gpio.txt: Explain expected pinctrl interaction
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, Chris Ball <cjb@laptop.org>,
        linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CACRpkdbPeVBv5VWefDvib5HmGF0K2gT79Mx7g-yviyQj33+Z-w@mail.gmail.com>
References: <1329719263-18971-1-git-send-email-swarren@nvidia.com> <CACRpkdbPeVBv5VWefDvib5HmGF0K2gT79Mx7g-yviyQj33+Z-w@mail.gmail.com>
Date: Mon, 12 Mar 2012 10:32:12 -0600
Message-Id: <20120312163212.70E283E07B0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Feb 2012 11:46:03 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Feb 20, 2012 at 7:27 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > Update gpio.txt based on recent discussions regarding interaction with the
> > pinctrl subsystem.
> >
> > Previously, gpio_request() was described as explicitly not performing any
> > required mux setup operations etc.
> >
> > Now, gpio_request() is explicitly as explicitly performing any required mux
> > setup operations where possible. In the case it isn't, platform code is
> > required to have set up any required muxing or other configuration prior to
> > gpio_request() being called, in order to maintain the same semantics.
> >
> > This is achieved by gpiolib drivers calling e.g. pinctrl_request_gpio() in
> > their .request() operation.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Grant can you take this one? I'd prefer for you to have a look at
> it as well.

I've taken this one, but left the 2nd for Olof.

g.

