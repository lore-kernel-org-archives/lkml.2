Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2HXPIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:08:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51386 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2HXPII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:08:08 -0400
Date: Fri, 24 Aug 2012 16:08:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ola.o.lilja@stericsson.com" <ola.o.lilja@stericsson.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "roger.xr.nilsson@stericsson.com" <roger.xr.nilsson@stericsson.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "STEricsson_nomadik_linux@list.st.com" 
	<STEricsson_nomadik_linux@list.st.com>
Subject: Re: [alsa-devel] [PATCH 14/17] ARM: ux500: Rename MSP board file to
 something more meaningful
Message-ID: <20120824150802.GP32491@gmail.com>
References: <1345816913-4113-1-git-send-email-lee.jones@linaro.org>
 <1345816913-4113-15-git-send-email-lee.jones@linaro.org>
 <1BAFE6F6C881BF42822005164F1491C33EA69B3A@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EA69B3A@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  arch/arm/mach-ux500/Makefile             |    2 +-
> >  arch/arm/mach-ux500/board-mop500-audio.c |  199 ++++++++++++++++++++++++++++++
> >  arch/arm/mach-ux500/board-mop500-msp.c   |  199 ------------------------------
> 
> Please use _M option when generating patches (git-format-patch -M ...).
> This will reduce the final patch size

Ah, I see. That's what Linus was going on about!

I can do that.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
