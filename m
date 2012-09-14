Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab2INKPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 06:15:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62764 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab2INKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 06:15:50 -0400
Date: Fri, 14 Sep 2012 11:15:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 12/19] i2c-nomadik: Register sub-devices when passed via
 Device Tree
Message-ID: <20120914101542.GT3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-13-git-send-email-lee.jones@linaro.org>
 <CACRpkdaCrus9SOpxyK+kV2gKr3sEZJsHCn6ivn2gA3ri0rcvHw@mail.gmail.com>
 <20120912105202.GD2624@pengutronix.de>
 <20120914082754.GE3374@gmail.com>
 <20120914084141.GA2630@pengutronix.de>
 <20120914090228.GH3374@gmail.com>
 <20120914093945.GB2630@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120914093945.GB2630@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Now there is:
> >   git://git.linaro.org/people/ljones/linux-3.0-ux500.git preview-for-next
> 
> OK from having a glimpse, I'd prefer to squash (or have squashed)
> 
> 	i2c: nomadik: Add Device Tree support to the Nomadik I2C driver
> 	i2c-nomadik: Register sub-devices when passed via Device Tree

Sure, no problem

> 	Documentation: Device Tree binding information for i2c-nomadik driver
> 		(Documentation should go along with the code)

I'm still not too sure about how this benefits anyone. You can ensure
the documentation is placed in an adjacent patch, so it's just as easy
to make reference to.

> into one patch and take that via the I2C tree. This will allow me to
> resolve the merge conflict in my tree on my own. I don't see a strong
> reason to have those go via arm-soc (like prevented build-failures or
> easier merges), if I missed such a reason, please let me know.

I don't have any good reasons for you not to take the patch(es) though
your tree. Please go ahead.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
