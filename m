Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab2BBTUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:20:21 -0500
Received: from antcom.de ([188.40.178.216]:50564 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab2BBTUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:20:19 -0500
Message-ID: <4F2AE1F0.2070200@antcom.de>
Date: Thu, 02 Feb 2012 20:20:16 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 6/7] LPC32xx: clock.c: USB PLL fix
References: <1327939327-7799-1-git-send-email-stigge@antcom.de> <1327939327-7799-6-git-send-email-stigge@antcom.de> <20120131103401.GJ2471@pengutronix.de> <4F293DAF.4050402@antcom.de> <20120202164920.GC3219@pengutronix.de>
In-Reply-To: <20120202164920.GC3219@pengutronix.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On 02/02/2012 05:49 PM, Wolfram Sang wrote:
> Yes, please repost this series with the updates. And without USB &
> MMC updates. Those updates should be in later series, when we
> actually add support for these devices.

OK, reposting.

> First step, I'd suggest: After you repost this series, I'll create
> a branch with the relevant patches (defconfig, buildfixes, clock
> fixes) and send a pull-request to Arnd/Olof. You can decide which
> issue you want to tackle next. I'd think MMC or USB are more of the
> lower hanging fruits, but I leave that to you.

I'd then first repost the GPIO fixes I posted previously and then look
after USB if that's fine for you. :-)

Thanks,

Roland
