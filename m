Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab2K1QpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:45:11 -0500
Received: from relay.ams1.hosting.nl ([82.197.222.253]:52566 "EHLO
	relay.ams1.hosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab2K1Qoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:54 -0500
X-Originating-IP: 80.100.26.140
Message-ID: <50B63F81.4050008@van-ginkel.eu>
Date: Wed, 28 Nov 2012 17:44:49 +0100
From: Sander van Ginkel <sander@van-ginkel.eu>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux-kernel@vger.kernel.org, kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] add hardware I2C support for ARM IMX23
References: <20121128152403.45224dvyaufb1j7n@62.129.139.42> <20121128150851.GA4659@pengutronix.de> <20121128171039.14705ltphptrp5kv@62.129.139.42> <20121128162452.GB4659@pengutronix.de>
In-Reply-To: <20121128162452.GB4659@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 121128-0, 28-11-2012), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tested with:
CONFIG_I2C_MXS=m
CONFIG_I2C_MXS=y

in combination with CONFIG_GPIO_MXS enabled and disabled

used kernels: 3.6 and 3.7.0-rc6

My I2C slave is a PCF8575 i/o expander with some LEDs at the output.
These are controlled through sysfs.

Just tested with "i2cdetc -y -r 0" that crashes with  "BUG: soft lockup 
- CPU#0 stuck for 22s!"
according to the docs (IMX23RM.pdf) the interrupts for I2C are 26 and 27 
that why I assigned these two in the dts.






