Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2CJKSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 05:18:20 -0500
Received: from d1.icnet.pl ([212.160.220.21]:55946 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab2CJKSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 05:18:18 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the omap_dss2 tree
Date: Sat, 10 Mar 2012 10:55:04 +0100
Message-ID: <1678557.FviZqEVemH@vclass>
Organization: Tele-Info-System, Poznan, PL
User-Agent: KMail/4.7.4 (Linux/3.1.10-gentoo-r1; KDE/4.7.4; i686; ; )
In-Reply-To: <20120308165116.d400947f35e40a923e9c6ad0@canb.auug.org.au>
References: <20120308165116.d400947f35e40a923e9c6ad0@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 of March 2012 16:51:16 Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-omap1/board-ams-delta.c between commit ddba6c7f7ec6
> ("OMAP1: pass LCD config with omapfb_set_lcd_config()") from the
> omap_dss2 tree and commits 5ca6180fa6d7 ("ARM: OMAP1: ams-delta:
> supersede custom led device by leds-gpio") and 2e3ee9f45b3c ("ARM: OMAP1:
> Move most of plat/io.h into local iomap.h") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Hi,
Your resolution looks good to me, thanks!
Janusz
