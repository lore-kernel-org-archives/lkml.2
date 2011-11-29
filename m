Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1K2L0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:26:47 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:64655 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473Ab1K2L0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:26:43 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAHi/1E5R8sT5/2dsb2JhbABDqnSBBoFyAQEEATocIwULCANGFA0YAyETiAUCtyYSiwwElFOJDYFQhzY
Date: Tue, 29 Nov 2011 12:23:14 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Thill <nico@openwrt.org>,
        Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Cercueil <paul@crapouillou.net>,
        Marc Zyngier <maz@misterjones.org>, Wan ZongShun <mcuos.com@gmail.com>,
        Alejandro Cabrera <aldaya@gmail.com>,
        "George G. Davis" <gdavis@mvista.com>,
        Sylver Bruneau <sylver.bruneau@googlemail.com>,
        Vitaly Wool <vital@embeddedalley.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Timo Kokkonen <timo.t.kokkonen@nokia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] watchdog: convert drivers/watchdog/* to use
	module_platform_driver()
Message-ID: <20111129112314.GK23376@infomag.iguana.be>
References: <1322546041.9040.1.camel@phoenix> <1322546187.9040.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322546187.9040.3.camel@phoenix>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

> This patch converts the drivers in drivers/watchdog/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Nicolas Thill <nico@openwrt.org>
> Cc: Florian Fainelli <florian@openwrt.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Paul Cercueil <paul@crapouillou.net>
> Cc: Marc Zyngier <maz@misterjones.org>
> Cc: Wan ZongShun <mcuos.com@gmail.com>
> Cc: Alejandro Cabrera <aldaya@gmail.com>
> Cc: "George G. Davis" <gdavis@mvista.com>
> Cc: Sylver Bruneau <sylver.bruneau@googlemail.com>
> Cc: Vitaly Wool <vital@embeddedalley.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Timo Kokkonen <timo.t.kokkonen@nokia.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Added to the linux-next branch of the watchdog tree (after stripping the wm*.c drivers out of the diff since Marc allready had a patch for that).

Kind regards,
Wim.

