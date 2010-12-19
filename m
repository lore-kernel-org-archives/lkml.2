Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0LSK6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 05:58:55 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:49714 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475Ab0LSK6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 05:58:54 -0500
From: Arun MURTHY <arun.murthy@stericsson.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "samu.p.onkalo@nokia.com" <samu.p.onkalo@nokia.com>
Date: Sun, 19 Dec 2010 11:57:56 +0100
Subject: RE: [PATCH] leds-lp5521: modify the way of setting led device name
Thread-Topic: [PATCH] leds-lp5521: modify the way of setting led device name
Thread-Index: AcudI+5NmAvvGDvTRDqAYZku+K58uACR1I5w
Message-ID: <F45880696056844FA6A73F415B568C6953716AA735@EXDCVYMBSTM006.EQ1STM.local>
References: <1292414108-2445-1-git-send-email-arun.murthy@stericsson.com>
 <1292504836.7561.3.camel@kolo>
In-Reply-To: <1292504836.7561.3.camel@kolo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oBJAxKfR001305

Hi Andrew,
	Since Richard is not active in the community, can you please push this
patch through your mm tree.

Thanks and Regards,
Arun R Murthy
--------------

> -----Original Message-----
> From: Onkalo Samu [mailto:samu.p.onkalo@nokia.com]
> Sent: Thursday, December 16, 2010 6:37 PM
> To: Arun MURTHY
> Cc: akpm@linux-foundation.org; rpurdie@rpsys.net; Linus WALLEIJ; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] leds-lp5521: modify the way of setting led device
> name
> 
> On Wed, 2010-12-15 at 17:25 +0530, ext Arun Murthy wrote:
> > Currently the led device name is fetched from the device_type in
> > I2C_BOARD_INFO which comes from the platform data. This name is in
> turn
> > used to create an entry in sysfs.
> >
> > If there exists two or more lp5521 on a particular platform, the
> > device_type in I2C_BOARD_INFO has to be the same, else lp5521 driver
> > probe wont be called and if used so, results in run time warning
> "cannot
> > create sysfs with same name" and hence a failure.
> >
> > The name that is used to create sysfs entry is to be passed by the
> > struct led_platform_data. Hence adding an element of type const char
> *
> > and change in lp5521 driver to use this name in creating the led
> device
> > if present else use the name obtained by I2C_BOARD_INFO.
> >
> > Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> 
> Looks ok.
> 
> I'll make similar patch for lp5523 at some point.
> 
> Acked-by: Samu Onkalo <samu.p.onkalo@nokia.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
