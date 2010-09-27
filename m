Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab0I0JWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:22:19 -0400
Received: from smtp.nokia.com ([192.100.122.230]:63953 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0I0JWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:22:17 -0400
From: <samu.p.onkalo@nokia.com>
To: <rpurdie@linux.intel.com>, <akpm@osdl.org>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 27 Sep 2010 11:21:40 +0200
Subject: RE: [PATCH 0/4] Led driver support for LP5521 and LP5523 chips
Thread-Topic: [PATCH 0/4] Led driver support for LP5521 and LP5523 chips
Thread-Index: ActViCMGo6gAkvClQdSxLb4TuZT0SwInIqDw
Message-ID: <62697B07E9803846BC582181BD6FB6B835EF64A9AA@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1284631946-5350-1-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1284631946-5350-1-git-send-email-samu.p.onkalo@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 27 Sep 2010 09:21:48.0390 (UTC) FILETIME=[6950E060:01CB5E25]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>-----Original Message-----
>From: linux-i2c-owner@vger.kernel.org [mailto:linux-i2c-
>owner@vger.kernel.org] On Behalf Of Onkalo Samu.P (Nokia-MS/Tampere)
>Sent: 16 September, 2010 13:12
>To: rpurdie@linux.intel.com

I haven't got any mails or comments from Richard about this driver. 
Also led tree here:
http://git.o-hand.com/cgit.cgi/linux-rpurdie-leds/

is not updated in 4 months.

I'm just wondering should I send this to somebody else than Richard Purdie?

I'll update the driver based on other comments and send v2 patch set.

-Samu

>Cc: linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: [PATCH 0/4] Led driver support for LP5521 and LP5523 chips
>
>Patch set provides support for LP5521 and LP5523 LED driver chips
>from National Semicondutor. Both drivers supports programmable engines
>and naturally LED class features.
>
>Documentation is provided as a part of the patch set.
>I created "leds" sub directory to Documentation.
>Perhaps rest of the leds* documentation should be moved
>there.
>
>Datasheets are freely available at National Semiconductor www pages.
>
>Tested to work in top of 2.6.36-RC4 kernel.
>
>Samu Onkalo (4):
>  leds: driver for National Semiconductor LP5521 chip
>  leds: Driver for National Semiconductors LP5523 chip
>  leds: Update LP552x support Kconfig and Makefile
>  Documentation: led drivers lp5521 and lp5523
>
> Documentation/leds/leds-lp5521.txt |   85 +++
> Documentation/leds/leds-lp5523.txt |   81 +++
> drivers/leds/Kconfig               |   18 +
> drivers/leds/Makefile              |    2 +
> drivers/leds/leds-lp5521.c         |  820 +++++++++++++++++++++++++++
> drivers/leds/leds-lp5523.c         | 1063
>++++++++++++++++++++++++++++++++++++
> include/linux/leds-lp5521.h        |   46 ++
> include/linux/leds-lp5523.h        |   46 ++
> 8 files changed, 2161 insertions(+), 0 deletions(-)
> create mode 100644 Documentation/leds/leds-lp5521.txt
> create mode 100644 Documentation/leds/leds-lp5523.txt
> create mode 100644 drivers/leds/leds-lp5521.c
> create mode 100644 drivers/leds/leds-lp5523.c
> create mode 100644 include/linux/leds-lp5521.h
> create mode 100644 include/linux/leds-lp5523.h
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
