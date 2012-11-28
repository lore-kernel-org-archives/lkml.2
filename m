Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2K1Rey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:34:54 -0500
Received: from relay.ams1.hosting.nl ([82.197.222.253]:52989 "EHLO
	relay.ams1.hosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab2K1Rex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:34:53 -0500
X-Originating-IP: 127.0.0.1
Message-ID: <20121128183448.94465bmyj68wqr08@62.129.139.42>
Date: Wed, 28 Nov 2012 18:34:48 +0100
From: "sander van ginkel" <sander@van-ginkel.eu>
To: "Wolfram Sang" <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] add hardware I2C support for ARM IMX23
References: <20121128152403.45224dvyaufb1j7n@62.129.139.42>
	<20121128150851.GA4659@pengutronix.de>
	<20121128171039.14705ltphptrp5kv@62.129.139.42>
	<20121128162452.GB4659@pengutronix.de> <50B63F81.4050008@van-ginkel.eu>
	<20121128170907.GC4659@pengutronix.de>
In-Reply-To: <20121128170907.GC4659@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Citeren "Wolfram Sang" <w.sang@pengutronix.de>:

>
> You might want to try my for-next branch or wait for 3.8-rc1, maybe
the
> DMA termination patch helps? Also enabling I2C debug messages is
> probably worth it.
>
> Regards,
>
>    Wolfram
>
> --
> Pengutronix e.K.                           | Wolfram Sang
      |
> Industrial Linux Solutions                 |
http://www.pengutronix.de/  |
>

Ok I will dig into this, your for-next branch contains the DMA  
termination patch, I presume?

