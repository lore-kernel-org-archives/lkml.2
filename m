Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab2IJQpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:45:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55365 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab2IJQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:45:48 -0400
Date: Mon, 10 Sep 2012 17:45:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 05/22] ASoC: Ux500: Enable MOP500 driver for Device Tree
Message-ID: <20120910164542.GF24506@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ+zgEf48qpCRg_fz9=_oSGohuSsFLQoC3BzTgSDdNnZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZ+zgEf48qpCRg_fz9=_oSGohuSsFLQoC3BzTgSDdNnZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ola poke.

On Tue, Aug 14, 2012 at 10:52:23AM +0200, Linus Walleij wrote:
> On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Here we ensure that the MOP500 audio driver will be probed during a
> > Device Tree boot. We also parse the sound node to link together the
> > codec, dma and the CPU-side Digital Audio Interface.
> >
> > CC: alsa-devel@alsa-project.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> But only if Mark agrees with the overall approach.
> 
> Yours,
> Linus Walleij

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
