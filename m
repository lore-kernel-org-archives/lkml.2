Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2BBBUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:20:50 -0500
Received: from mail2.nsc.com ([12.238.8.132]:46536 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753047Ab2BBBUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:20:49 -0500
X-WSS-ID: 0LYQRQL-0A-6D8-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Axel Lin" <axel.lin@gmail.com>
cc: "Richard Purdie" <rpurdie@rpsys.net>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 1 Feb 2012 17:20:33 -0800
Subject: RE: [PATCH] backlight: lp855x_bl: Add missing mutex_unlock in
 lp855x_read_byte error path
Thread-Topic: [PATCH] backlight: lp855x_bl: Add missing mutex_unlock in
 lp855x_read_byte error path
Thread-Index: AczgzaXSf+lgymhTS9KTzbBa2KA60AAelhEg
Message-ID: <B567DBAB974C0544994013492B949F8E3812DED507@EXMAIL03.scwf.nsc.com>
References: <1328092698.2326.1.camel@phoenix>
In-Reply-To: <1328092698.2326.1.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 63373B6C1LS10089006-02-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q121KvQL024823


> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Wednesday, February 01, 2012 7:38 PM
> To: linux-kernel@vger.kernel.org
> Cc: Richard Purdie; Kim, Milo; Andrew Morton
> Subject: [PATCH] backlight: lp855x_bl: Add missing mutex_unlock in
> lp855x_read_byte error path
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Thanks !

Best Regards,
Milo -
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
