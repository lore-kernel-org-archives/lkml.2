Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab2DROCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:02:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49678 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2DROB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:01:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v2 8/8] ARM: LPC32xx: Device tree support
Date: Wed, 18 Apr 2012 14:01:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Thierry Reding <thierry.reding@avionic-design.de>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
References: <1334682507-15055-1-git-send-email-stigge@antcom.de> <20120418060230.GC17506@avionic-0098.adnet.avionic-design.de> <4F8EB3DC.3060203@antcom.de>
In-Reply-To: <4F8EB3DC.3060203@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204181401.53913.arnd@arndb.de>
X-Provags-ID: V02:K0:WiS4C0k03oFQ94z2opK5IzgDVFaJll+jTtb6WqYJkIK
 oRj6Z12fj5vvniDNRsNbq+BixhzTkMC9WqiLjfSbmiAQdkWNas
 dKO837yMpONN2axbbdV7dCBllx7r1qgh1aQt0V5daxBV5MurU8
 oafOMWlIktU/YPvpKerj9J+bW2Jw3XJvUpm7cYrtUZwcdnCovR
 65E2X7wcUiwvWp7C8/lh7Ag2F34KjBsqUs5vgjm7ejlcfQlaMi
 xzXkknOKLZV6Ins1vfb9aWsncQ7vj7Y0UB3BbtD0pXEE5GruYb
 85xJrkhfTcAR5vom9JMUl1+l8pgflBcaEAlhcNvANFgHELM3Hd
 nZoLN0gNBaPf+sgsvFI8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2012, Roland Stigge wrote:
> As Arnd wrote, there are board specific bits left (open questions
> about how to DT'ize spi's controller_data, and DT-conversion of AMBA
> CLCD). However, I will move board-independent stuff over to common.c.
> (Keeping lpc32xx_auxdata_lookup[] in phy3250.c due to remaining
> platform_data, though.)

FWIW, I think you can remove the most of the auxdata table if you
change the clock lookup table to refer to the automatic device
names, e.g. 31020000.usbd instead of lpc32xx_udc.

	Arnd
