Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1KXTiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:38:08 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:35600 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517Ab1KXTiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:38:06 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPeczk5tg6zW/2dsb2JhbABDqnKBBoFyAQEEATocIxAIA0YUJQMhiBgCtFUSilAElEmSDQ
Date: Thu, 24 Nov 2011 20:34:29 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Marc Vertes <marc.vertes@sigfox.com>
Cc: HaraldWelte@viatech.com, w.sang@pengutronix.de, mad_soft@inbox.ru,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111124193429.GU23376@infomag.iguana.be>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com> <20111122112212.GD2734@pengutronix.de> <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com> <20111122173029.GA14349@pengutronix.de> <4ecbe56d.0B7WEVDKkK1s88MJ%marc.vertes@sigfox.com> <4ecbf011.dZASXe6D5kH4Uxve%marc.vertes@sigfox.com> <20111123121051.GA18320@rainbow> <20111123182209.GF5315@prithivi.gnumonks.org> <20111123214115.GO23376@infomag.iguana.be> <4ece995e.x4p0mK5XK7QoXS86%marc.vertes@sigfox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ece995e.x4p0mK5XK7QoXS86%marc.vertes@sigfox.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

> > The BIOS can at least start the hardware, so the hardware does work :-)
> >
> Hey, I just discovered that enabling Plug&Play in the BIOS is the key!
> 
> It unlocks watchdog control registers and opens access to counters and
> all the stuff. Sometimes lateral thinking helps :-)
> 
> So the driver will be able to normally support all features as documented
> in the datasheet. I plan an update tomorrow.

Nice !!! Please add a note about the fact that you need to enable PnP in the
driver.

Kind regards,
Wim.

