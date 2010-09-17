Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0IQNmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:42:10 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:51876 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754457Ab0IQNmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:42:08 -0400
Message-ID: <4C93702D.4030500@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:42:05 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: platform: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------060905080306050608000808"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060905080306050608000808
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...
Last (14 buses)






--------------060905080306050608000808
Content-Type: text/plain;
 name="mod-platform.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mod-platform.patch"

Fix lost PLATFORM modalias

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/sound/soc/sh/fsi.c	2010-09-17 12:30:32.000000000 +0300
+++ b/sound/soc/sh/fsi.c	2010-09-17 12:39:08.026437283 +0300
@@ -1250,6 +1250,9 @@ static void __exit fsi_mobile_exit(void)
 {
 	platform_driver_unregister(&fsi_driver);
 }
+
+MODULE_DEVICE_TABLE(platform, fsi_id_table);
+
 module_init(fsi_mobile_init);
 module_exit(fsi_mobile_exit);
 

--------------060905080306050608000808--
