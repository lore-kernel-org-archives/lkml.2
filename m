Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029Ab2EQHLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:11:20 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:45180 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759685Ab2EQHLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:11:17 -0400
Date: Thu, 17 May 2012 09:11:12 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH -next] wdt: ie6xx_wdt needs io.h
Message-ID: <20120517071112.GS3074@spo001.leaseweb.com>
References: <20120514200357.e7448e4ca061c8efe3d4757d@canb.auug.org.au> <4FB167A5.9010905@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB167A5.9010905@xenotime.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randi,

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build error by including <linux/io.h>:
> 
> drivers/watchdog/ie6xx_wdt.c:97:2: error: implicit declaration of function 'outb'
> drivers/watchdog/ie6xx_wdt.c:133:2: error: implicit declaration of function 'outl'
> drivers/watchdog/ie6xx_wdt.c:161:2: error: implicit declaration of function 'inb'
> drivers/watchdog/ie6xx_wdt.c:199:3: error: implicit declaration of function 'inl'
> drivers/watchdog/ie6xx_wdt.c:203:3: error: implicit declaration of function 'inw'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc:	Wim Van Sebroeck <wim@iguana.be>

Added to linux-watchdog-next.

Kind regards,
Wim.

