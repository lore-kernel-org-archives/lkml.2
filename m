Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2BGKG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:06:56 -0500
Received: from mail2.nsc.com ([12.238.8.132]:48754 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754284Ab2BGKGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:06:54 -0500
X-WSS-ID: 0LZ0PFD-0A-4LG-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Axel Lin" <axel.lin@gmail.com>
cc: "Shreshtha Kumar Sahu" <shreshthakumar.sahu@stericsson.com>,
        "Richard Purdie" <rpurdie@rpsys.net>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Feb 2012 02:06:33 -0800
Subject: RE: [PATCH RFC] leds: lm3530: Fix setting pltfm->als_vmax
Thread-Topic: [PATCH RFC] leds: lm3530: Fix setting pltfm->als_vmax
Thread-Index: AczlYPuA/SuEVtp/QCKnghWd9Vn+zQAHM+ZQ
Message-ID: <B567DBAB974C0544994013492B949F8E3812ED4697@EXMAIL03.scwf.nsc.com>
References: <1328595786.5274.6.camel@phoenix>
In-Reply-To: <1328595786.5274.6.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 632E28211LS10200292-02-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q17A72Lk026963


> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Tuesday, February 07, 2012 3:23 PM
> To: linux-kernel@vger.kernel.org
> Cc: Shreshtha Kumar Sahu; Kim, Milo; Richard Purdie; Andrew Morton
> Subject: [PATCH RFC] leds: lm3530: Fix setting pltfm->als_vmax
> 
> In current code, pltfm->als_vmin is set to LM3530_ALS_WINDOW_mV and
> pltfm->als_vmax is 0. This looks does not make sense.
> I think what we want here is setting pltfm->als_vmax to
> LM3530_ALS_WINDOW_mV.
> 
> Both als_vmin and als_vmax local variables will be set to pltfm-
> >als_vmin and
> pltfm->als_vmax by a few lines latter.
> Thus also remove a redundant assignment for als_vmin and als_vmax in
> this patch.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

This patch makes sense and fixes wrong range of the ALS input voltage.
It works well on the real board.
Thanks.

Acked-and-tested-by: Milo(Woogyom) Kim <milo.kim@ti.com>

BTW, I'd suggest that 'pltfm' is replaced with 'pdata' if below patch has been updated.
[PATCH v4 5/5] leds-lm3530: replace pltfm with pdata.

Best Regards,
Milo -
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
