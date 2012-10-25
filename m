Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206Ab2JYIXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:23:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56178 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573Ab2JYIXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:23:46 -0400
Date: Thu, 25 Oct 2012 09:23:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
Message-ID: <20121025082341.GC3348@gmail.com>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
 <1351089926-32161-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdaeBW2ecQZ2fA-hL8o47pYpjZ=5Mn131F87u58rX+dekw@mail.gmail.com>
 <20121025073127.GB971@gmail.com>
 <5088F0EE.8030900@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5088F0EE.8030900@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Linus Walleij wrote:

> On 10/25/2012 09:31 AM, Lee Jones wrote:
> >
> >This certainly doesn't fix the bug we spoke about. I believe Ulf
> >is still working on that one.
> >
> >So do you want me to remove this patch?
> >
> 
> Yeah drop it for now.

Actually, a quick question before I do:

If it's better/faster to prepare the clock and keep it prepared
while you do clk_enable/clk_disable, why don't we do that in all
drivers? Why do we bother to prepare/unprepare each time if all
it does is take up cycles?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
