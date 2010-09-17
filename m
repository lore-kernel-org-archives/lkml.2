Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0IQNiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:38:51 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:44471 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752830Ab0IQNiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:38:50 -0400
Message-ID: <4C936F8A.1040603@bspu.unibel.by>
Date: Fri, 17 Sep 2010 16:39:22 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RapidIO: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au>
In-Reply-To: <201009111144.34078.rusty@rustcorp.com.au>
Content-Type: multipart/mixed;
 boundary="------------050900020104020905000000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050900020104020905000000
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

...






--------------050900020104020905000000
Content-Type: text/plain;
 name="mod-rapidio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mod-rapidio.patch"

Fix lost RapidIO modalias

Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>

--- linux-2.6.36-rc4-git3/drivers/net/rionet.c	2010-08-02 01:11:14.000000000 +0300
+++ b/drivers/net/rionet.c	2010-09-17 12:38:54.942480418 +0300
@@ -571,5 +571,8 @@ static void __exit rionet_exit(void)
 	rio_unregister_driver(&rionet_driver);
 }
 
+
+MODULE_DEVICE_TABLE(rio, rionet_id_table);
+
 module_init(rionet_init);
 module_exit(rionet_exit);

--------------050900020104020905000000--
