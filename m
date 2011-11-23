Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab1KWVod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:44:33 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:38503 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab1KWVoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:44:32 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAGBozU5tg6zW/2dsb2JhbABEqnKBBoFyAQEEATocIwULCANGFCUDIYgYArRTEopQBJRHkgw
Date: Wed, 23 Nov 2011 22:41:15 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, Marc Vertes <marc.vertes@sigfox.com>,
        w.sang@pengutronix.de, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111123214115.GO23376@infomag.iguana.be>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com> <20111122112212.GD2734@pengutronix.de> <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com> <20111122173029.GA14349@pengutronix.de> <4ecbe56d.0B7WEVDKkK1s88MJ%marc.vertes@sigfox.com> <4ecbf011.dZASXe6D5kH4Uxve%marc.vertes@sigfox.com> <20111123121051.GA18320@rainbow> <20111123182209.GF5315@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123182209.GF5315@prithivi.gnumonks.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harald,

> Unfortunately it simply doesn't work.  When I originally implemented a
> via_wdt driver some years ago, I couldn't start the watchdog no matter
> how hard I tried.  My inquiries into VIA at that point didn't provide
> any response either.  In fact, I even feared that nobody might ever have
> used that watchdog hardware before ;)
> 
> I can ask again, but I'm not sure if it will be any different at that
> time..

Could you please ask again? It could indeed be that they lock registers.
(It could be something similar to some of the superIO chipsets that can
enable/disable (lock/unlock) access to registers).

The BIOS can at least start the hardware, so the hardware does work :-)

Note: I saw your disclaimer and I thus have no high hopes :-).

Thanks in advance,
Wim.

