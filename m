Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2FDR35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:29:57 -0400
Received: from tex.lwn.net ([70.33.254.29]:50689 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab2FDR34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:29:56 -0400
Date: Mon, 4 Jun 2012 11:30:17 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] gpiolib: wm8994: Use irq_domain mappings for gpios
Message-ID: <20120604113017.585830e5@tpl.lwn.net>
In-Reply-To: <CACRpkdZJPH__FzsUmKnQhTOtJ1EstJ8K5LzhTXGUO_VSzrjLew@mail.gmail.com>
References: <1338727219-24141-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<CACRpkdZJPH__FzsUmKnQhTOtJ1EstJ8K5LzhTXGUO_VSzrjLew@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012 19:08:43 +0200
Linus Walleij <linus.walleij@linaro.org> wrote:

> I read some drivers/base/regmap code and I think I understand this stuff
> now, but seriously, it's quite hard to see the forest with all these trees,
> and regmap is actually one of the finest new things in recent kernels,
> so can could we create
> Documentation/driver-model/regmap.txt?

That's actually on my list of things to do (by way of LWN, of course).
I just need to get my hands dirty first, probably by converting the
ov7670 driver.  Unfortunately, I have some serious distractions in my
life at the moment, so I can't make any promises as to when this will
happen...

jon
