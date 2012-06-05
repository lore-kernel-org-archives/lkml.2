Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2FEPnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:43:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45860 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab2FEPnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:43:23 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: [RFC] clean up headers for light drivers : backlights, leds and
 iio-light
Thread-Topic: [RFC] clean up headers for light drivers : backlights, leds
 and iio-light
Thread-Index: Ac1DMebzgj+NhOPmQCOPkZnXWmi9vA==
Date: Tue, 5 Jun 2012 15:43:08 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FAD86@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to suggest some clean up idea for headers under include/linux.
Light device drivers are exist under 'drivers/leds' and 'drivers/video/backlight'.
(and iio light drivers are ongoing in staging directory)
At this moment, there is no specific directory for light driver, some headers are located in include/linux.
Furthermore, new light drivers may be added into include/linux again and again.

So my suggestion is 

- create new directory for light driver : include/linux/light
- move driver headers into this directory
- change header declaration per each driver source

Here is the cleanup list of light drivers.

(leds and backlight)
include/linux/apple_bl.h
include/linux/atmel_pwm.h
include/linux/backlight.h
include/linux/led-lm3530.h
include/linux/leds-bd2802.h
include/linux/leds.h
include/linux/leds-lm3556.h
include/linux/leds-lp3944.h
include/linux/leds-lp5521.h
include/linux/leds-lp5523.h
include/linux/leds-pca9532.h
include/linux/leds_pwm.h
include/linux/leds-regulator.h
include/linux/leds-tca6507.h
include/linux/lp855x.h
include/linux/pwm_backlight.h

(iio/backlight)
drivers/staging/iio/light/tsl2563.h
drivers/staging/iio/light/tsl2x7x.h

I'd like to have your opinion.

Thanks & BR
Milo -


