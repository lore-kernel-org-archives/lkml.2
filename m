Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0IQNho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:37:44 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:44463 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752804Ab0IQNhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:37:43 -0400
Message-ID: <4C936F64.4000403@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:38:44 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: spi Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------010701050403070902090500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010701050403070902090500
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...





--------------010701050403070902090500
Content-Type: text/plain;
 name="mod-spi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mod-spi.patch"

Fix lost SPI modalias

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/drivers/staging/iio/imu/adis16350_core.c	2010-09-17 12:30:31.000000000 +0300
+++ b/drivers/staging/iio/imu/adis16350_core.c	2010-09-17 12:39:01.312564201 +0300
@@ -724,6 +724,9 @@ static __init int adis16350_init(void)
 {
 	return spi_register_driver(&adis16350_driver);
 }
+
+MODULE_DEVICE_TABLE(spi, adis16350_id);
+
 module_init(adis16350_init);
 
 static __exit void adis16350_exit(void)

--------------010701050403070902090500--
