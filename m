Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2K1QKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:10:46 -0500
Received: from relay.ams1.hosting.nl ([82.197.222.253]:52176 "EHLO
	relay.ams1.hosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab2K1QKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:10:45 -0500
X-Originating-IP: 127.0.0.1
Message-ID: <20121128171039.14705ltphptrp5kv@62.129.139.42>
Date: Wed, 28 Nov 2012 17:10:39 +0100
From: "sander van ginkel" <sander@van-ginkel.eu>
To: "Wolfram Sang" <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] add hardware I2C support for ARM IMX23
References: <20121128152403.45224dvyaufb1j7n@62.129.139.42>
	<20121128150851.GA4659@pengutronix.de>
In-Reply-To: <20121128150851.GA4659@pengutronix.de>
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

> Have you tested it? There have been problems reported when using
> i2cdetect...
>
> --
> Pengutronix e.K.                           | Wolfram Sang
      |
> Industrial Linux Solutions                 |
http://www.pengutronix.de/  |
>

I've tested it with multiple configs.
i2cdetect -l gives me:
i2c-0   i2c             MXS I2C adapter                         I2C adapter



