Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2LRLvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 06:51:24 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:45166 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab2LRLvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 06:51:22 -0500
Date: Tue, 18 Dec 2012 12:51:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Amaury =?ISO-8859-1?B?RGVjcuptZQ==?= <amaury.decreme@gmail.com>
Cc: "Wolfram Sang" <w.sang@pengutronix.de>, nelson@sis.com,
        mhoffman@lightlink.com, amalysh@web.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 0/2] I2C: sis630: add sis964 support
Message-ID: <20121218125105.25c2cbb6@endymion.delvare>
In-Reply-To: <1346204115-30293-1-git-send-email-amaury.decreme@gmail.com>
References: <1346204115-30293-1-git-send-email-amaury.decreme@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amaury,

On Wed, 29 Aug 2012 03:35:13 +0200, Amaury Decrême wrote:
> This serie of patches brings SIS964 support to i2c-sis630.
> 
> The SiS datasheets have been used.
> 
> The SIS964 isn't part of the SIS96X family and behaves differently.
> For i2c, this array show the differences between sis630 and sis964.
> 	+------------------------+--------------------+-------------------+
> 	|                        |     SIS630/730     |      SIS964       |
> 	+------------------------+--------------------+-------------------+
> 	| Clock                  | 14kHz/56kHz        | 55.56kHz/27.78kHz |
> 	| SMBus registers offset | 0x80               | 0xE0              |
> 	| SMB_CNT                | Bit 1 = Slave Busy | Bit 1 = Bus probe |
> 	| SMB_COUNT              | 4:0 bits           | 5:0 bits          |
> 	+------------------------+--------------------+-------------------+
> 
> The other differences doesn't affect the functions provided by the original
> i2c-sis630 driver.
> 
> The first patch is mandatory as it adds supports for SIS964 bus.
> The second patch is optional. It depends on the first patch.
> 
> Amaury Decrême (2):
>   I2C: sis630: sis964 bus
>   I2C: sis630: Cleaning and cosmetics
> 
>  Documentation/i2c/busses/i2c-sis630 |   17 +-
>  drivers/i2c/busses/Kconfig          |    4 +-
>  drivers/i2c/busses/i2c-sis630.c     |  445 +++++++++++++++++++++--------------
>  3 files changed, 278 insertions(+), 188 deletions(-)

I reviewed these two patches 2 months ago, but did not hear back from
you since then. Do you plan to resubmit these patches with the
improvements I suggested? I would hate to see your work time and mine
wasted.

Thanks,
-- 
Jean Delvare
