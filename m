Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030909Ab2CULQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 07:16:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50847 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030868Ab2CULQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 07:16:17 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 21 Mar 2012 04:16:14 -0700
Subject: RE: [PATCH] backlight: Use id->driver_data to differentiate lp855x
 chips
Thread-Topic: [PATCH] backlight: Use id->driver_data to differentiate lp855x
 chips
Thread-Index: Ac0HSwEfLGi41LSMTxaSV6hj/PfTuQAB8/cg
Message-ID: <B567DBAB974C0544994013492B949F8E38134414EB@EXMAIL03.scwf.nsc.com>
References: <1332324687.12310.2.camel@phoenix>
In-Reply-To: <1332324687.12310.2.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2LBGU9P009821

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Wednesday, March 21, 2012 7:11 PM
> To: linux-kernel@vger.kernel.org
> Cc: Richard Purdie; Kim, Milo; Andrew Morton
> Subject: [PATCH] backlight: Use id->driver_data to differentiate lp855x
> chips
> 
> Current code has corresponding driver_data settings for different chip
> types.
> Use the driver_data to differentiate lp855x chips.
> 
> Also make lp855x_is_valid_rom_area() return bool instead of int.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks for catching this !

Signed-off-by: Milo (Woogyom) Kim <milo.kim@ti.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
