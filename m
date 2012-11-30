Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab2K3Qck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:32:40 -0500
Received: from relay.ams1.hosting.nl ([82.197.222.253]:49461 "EHLO
	relay.ams1.hosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356Ab2K3Qci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:32:38 -0500
X-Originating-IP: 127.0.0.1
Message-ID: <20121130173224.10203ha9fee3y36g@62.129.139.42>
Date: Fri, 30 Nov 2012 17:32:24 +0100
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

I've tested your git tree, with the same config as I used for the  
3.7.0-rc6 release (IMX i2c build in)
It's not a 100% fix

If I do "i2cdetect -y -r 0" with 3.7.0-rc6, i2cdetect gets confused  
and the kernel keeps dumping "mxs-i2c 80058000.i2c: Failed to get PIO  
reg. write descriptor."
If I do the same with your git release I get the same result, but only  
when i2cdetect is running. When it's finished or I terminate, the  
kprint will also disappear.
So there is some improvement but not 100% yet.


