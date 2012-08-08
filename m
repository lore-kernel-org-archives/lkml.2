Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab2HHNKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:10:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45449 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab2HHNKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:10:04 -0400
Date: Wed, 8 Aug 2012 14:09:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, w.sang@pengutronix.de, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] i2c: Add default configuration into the Nomadik
 I2C driver.
Message-ID: <20120808130958.GC8227@gmail.com>
References: <1344266253-14050-1-git-send-email-lee.jones@linaro.org>
 <20120806153503.GH10524@gmail.com>
 <CACRpkdZjbyQbht+UpXrrVGhAzGYPjb=HRZhJ+TvsEXhGeviJLA@mail.gmail.com>
 <20120807153112.GF10719@gmail.com>
 <CACRpkdZj2LqFF_i6f3M2uzUkhG6og5n2cTzUgqRZA1_NmhWBNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZj2LqFF_i6f3M2uzUkhG6og5n2cTzUgqRZA1_NmhWBNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 02:38:23PM +0200, Linus Walleij wrote:
> On Tue, Aug 7, 2012 at 5:31 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > From: Lee Jones <lee.jones@linaro.org>
> > Date: Tue, 7 Aug 2012 12:27:24 +0100
> > Subject: [PATCH 1/1 v3] i2c: Add default configuration into the Nomadik I2C
> >  driver.
> 
> This has some bad whitespace damage, and the subject should
> be "i2c/nomadik:"

White space damage? You mean the subject line-wrap? 

`git format-patch` does that. I'll change the subject line to i2c/nomadik.

> > Cc: linux-i2c@vger.kernel.org
> > Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Double sign-off.

Hmm... this is fast becoming my nemosis patch!

> Unless Wolfram volunteers to fix this up I suggest you
> fix it nocheinmal und senden einer neues version.

That's okay, it's my error, I'll fix. 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
