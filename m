Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2ISOty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:49:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59678 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2ISOtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:49:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 13/16] ARM: omap: move platform_data definitions
Date: Wed, 19 Sep 2012 14:49:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        =?utf-8?q?Beno=C3=AEt_Cousson?= <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Ohad Ben-Cohen" <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jean Pihet <j-pihet@ti.com>, J Keerthy <j-keerthy@ti.com>,
        linux-omap@vger.kernel.org
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <201209121720.33822.arnd@arndb.de> <5058458C.5010908@ti.com>
In-Reply-To: <5058458C.5010908@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209191449.30935.arnd@arndb.de>
X-Provags-ID: V02:K0:Sr1ipu3C9CupXOhtoj87dRMn4ueW49BK9sGeEsG7znA
 p6bYn4JJ+5Xaj5JjLtHBe4wuGkJ9yAMbpcUhj1zsurl5O0vAA1
 5AXax/LhjH3pRhvBciQ0EtIr2TGjxpa7DahM8SDyTWXHa5e44F
 oqQXMwXwhlY0vjVIkH0SIA/zdMBCE+ipnKw8yYFwTNwHUAir7D
 ymdizn+2jt3e0BSfrt6sP1btU56KiSb82qshVYxYrn0z70W0E1
 47J6Jb1Zeki+xGD4usOD1u1BDm0QILnaUhRNXtaGz5O2rWMWqy
 i/QXeVqIBXOTuPR5+2Quf1uLgeJ9hbr2J5jB4hNBpiKlz469Mu
 0TEik+S4UlnTrME9e0yQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012, Peter Ujfalusi wrote:
> I thought I have replied to this...
> Whichever way you prefer. I can craft a series to clean up the plat/mcbsp.h
> usage and move the mcbsp header via ASoC tree.
> I'm also fine if you do the move.
> Let me know what you prefer.
> 

I think I'll just keep all my patches together then, and leave this one in.

	Arnd
