Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2DBNpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 09:45:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57205 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab2DBNpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 09:45:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH 0/7]: arm: lpc32xx: Device tree support
Date: Mon, 2 Apr 2012 13:45:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, srinivas.bakki@nxp.com, kevin.wells@nxp.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-watchdog@vger.kernel.org, wim@iguana.be
References: <1333371364-21347-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1333371364-21347-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204021345.04512.arnd@arndb.de>
X-Provags-ID: V02:K0:yZAlqP8jLTHwZMJbYPUfctkT/PoJqr+OxrFUpMQai+Y
 /0t6nwYhSkztqM8SDNnMOuIORugi+/SMMg343mjCsYmcVD+ZgF
 ON0xPjlgKGChjLL2/uEU/rBKWkIyz0Dbisgkb6rO7w6YSF0SrS
 N5IAUuqcN4dK8jLyhgZmTRVGeeghtjF+x/hnsLQI/ZEmA+eJrf
 SG5rbxnXJCWxKG4W33Ys4tvcv85SmmLBYFzcF7MaLXHEPvREyF
 kAnZRyzg6sAKWE+ZUXaZxbE5Guf1TbFFV2eid8DJbfMI5ZThqI
 UOIs62qr9i7zHC3PM383ZJFWONfX9xTrAKq22Wo7WW16FKW8Ei
 12W5DvrSEisc0F48E5iY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2012, Roland Stigge wrote:
> This is the first series of patches to introduce device tree support for the
> LPC32xx SoC. This series includes patches for the various subsystems to support
> device tree to be used later by the machine's initialization.
> 
> The patches apply to various subsystems:
> 
>  * staging/iio/adc
>  * rtc
>  * net
>  * arm-soc
>  * i2c
>  * wdt
> 
> Based on v3.4-rc1
> 
> You can also pull from
> 
>   git://git.antcom.de/linux-2.6 lpc32xx/dt
> 
> I'm CC'ing the various subsystem maintainers and lists who can each see what's
> going on and please pick their respective subsystem's changes. - Thanks!
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Looks good overall.

I notice that you are missing the bindings for irq and gpio, which tend to be
quite important. Do you have another tree that has all the lpc32xx specific
parts or are these still under heavy development?

Do you plan to add DT support in parallel to the ATAGS based board you
already have, or do you plan to move everything over quickly?
In the latter case, it might be helpful to get Acks from the subsystem
maintainers and merge everything through arm-soc.

	Arnd
