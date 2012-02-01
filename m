Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab2BAN1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:27:19 -0500
Received: from antcom.de ([188.40.178.216]:54019 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab2BAN1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:27:17 -0500
Message-ID: <4F293DAF.4050402@antcom.de>
Date: Wed, 01 Feb 2012 14:27:11 +0100
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
References: <1327939327-7799-1-git-send-email-stigge@antcom.de> <1327939327-7799-6-git-send-email-stigge@antcom.de> <20120131103401.GJ2471@pengutronix.de>
In-Reply-To: <20120131103401.GJ2471@pengutronix.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Thanks for reviewing my patches! I collected (and applied) all your
suggestions and will re-post the series as a patch update for applying
to the mainline tree.

On 01/31/2012 11:34 AM, Wolfram Sang wrote:
> I remember we needed that fix back then as well, so I am tempted to
> ack it. However, I'd like to test it but USB is currently not
> available. Do you happen to have a USB fixing commit just to test
> (can be hackish)?

I'm posting this one separately (to be applied on top of all my and
your posted patches).

What do you think about mainline-integrating it?

Thanks in advance!
