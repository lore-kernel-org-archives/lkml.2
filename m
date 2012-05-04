Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab2EDM6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:58:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab2EDM6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:58:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v8] gpio: Device tree support for LPC32xx
Date: Fri, 4 May 2012 12:57:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: grant.likely@secretlab.ca, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com
References: <1336076428-29419-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1336076428-29419-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041257.58252.arnd@arndb.de>
X-Provags-ID: V02:K0:y30R+wW005NDQYuPIpSj8bvJUhHA6D5/HfVkRwQrT5S
 66CBWMUebvz/D8V+bTlPtCXxYLDYm8omwucP+ugPoV2Qjhsqdf
 DPI8f38yzSDvegSFbUUsPNu4/CenxHs4XsP0Ws7NrcupG4y/p7
 R11JrGn6tSMYfRSxWF853lDB+M533ZEoLGkDNWsrfc+lVA8iDi
 dBf4Nlpm2KjZPKWqQScUKnyhRHCinW9kNaHWvnxR0D+bXSEH9H
 E1xJxqpqjIC3i0ZF9mbVbR3lezL7lwfBClhqbY1FwJrIa/yxMp
 1XgOkPisW9BhM+TLcYMNMkS/1TBqhLqJFIzLa36Jp/o9DHuVo/
 OeJZuc7MC+wGXjBXTxl0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2012, Roland Stigge wrote:
> This patch adds device tree support for gpio-lpc32xx.c.
> 
> The various GPIO groups correspond to the different irregular GPIO banks of the
> LPC32xx hardware. Most importantly, there are the GPI(0-27), GPO(0-23) and
> GPIO(0-5) banks. Each bank must be registered individually since they are
> implemented with different functions. Registration is done via gpiochip_add()
> which requires an individual gpio bank subnode in the device tree for each
> call.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
