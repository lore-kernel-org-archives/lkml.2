Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2HGLlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:41:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55488 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab2HGLlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:41:20 -0400
Date: Tue, 7 Aug 2012 12:41:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, w.sang@pengutronix.de, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] i2c: Add default configuration into the Nomadik
 I2C driver.
Message-ID: <20120807114113.GA5684@gmail.com>
References: <1344266253-14050-1-git-send-email-lee.jones@linaro.org>
 <20120806153503.GH10524@gmail.com>
 <CACRpkdZjbyQbht+UpXrrVGhAzGYPjb=HRZhJ+TvsEXhGeviJLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZjbyQbht+UpXrrVGhAzGYPjb=HRZhJ+TvsEXhGeviJLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/drivers/gpu/mali/mali400ko/driver/src/devicedrv/mali/arch b/drivers/gpu/mali/mali400ko/driver/src/devicedrv/mali/arch
> > new file mode 120000
> > index 0000000..427334b
> > --- /dev/null
> > +++ b/drivers/gpu/mali/mali400ko/driver/src/devicedrv/mali/arch
> > @@ -0,0 +1 @@
> 
> NACK, what is this stuff? It's even out-of-tree code.

Whoa, no idea! Good spot though, I missed this completely.

> Please be careful with git add -A, I prefer to use git add <pathspec>
> I suspect that may be why this happened...

I don't use `git add -A`, ever. If I'm adding files, I usually use 
`git commit -s -- <pathspec>`, or `git commit -a` if I'm sure I require
all the necessary changes. I guess I could have accidentally collected 
it using `git add -i` whist fixing it up, or a similar misdemeanor.

> Please fix it up and send a v3.

Of course.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
