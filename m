Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2IJQp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:45:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37240 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab2IJQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:45:24 -0400
Date: Mon, 10 Sep 2012 17:45:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 06/22] ASoC: Ux500: Enable ux500 MSP driver for Device
 Tree
Message-ID: <20120910164518.GE24506@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-7-git-send-email-lee.jones@linaro.org>
 <CACRpkdb09UnPj6xV-rNxoeUS2yPLurA+n6zygWEA3_7OQfb0nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdb09UnPj6xV-rNxoeUS2yPLurA+n6zygWEA3_7OQfb0nA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ola poke.

On Tue, Aug 14, 2012 at 10:55:59AM +0200, Linus Walleij wrote:
> On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Register both parts of the MSP driver from Device Tree so that they
> > are probed when Device Tree is enabled. Also, as there is platform
> > data involved, we ensure that there is allocated memory to place the
> > configuration into and that the correct information is extracted from
> > the DT binary.
> >
> > CC: alsa-devel@alsa-project.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Looks like it's doing what's intended...
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Yours,
> Linus Walleij

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
