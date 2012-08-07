Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2HGIEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:04:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36691 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2HGIEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:04:01 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@gmail.com>, Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFT] leds: lp8788: Fix updating scale configuration bits
Thread-Topic: [PATCH RFT] leds: lp8788: Fix updating scale configuration bits
Thread-Index: AQHNb+LfXR8JfzaAFkiwBVrdjvH+C5dOBXSg
Date: Tue, 7 Aug 2012 08:03:45 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FEBCF@DQHE02.ent.ti.com>
References: <1343824834.3859.2.camel@phoenix>
In-Reply-To: <1343824834.3859.2.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7784KKI011098

> We need to do left shift (cfg->num + LP8788_ISINK_SCALE_OFFSET) bits
> for
> updating scale configuration.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Hi Milo,
> Current code of updating scale configuration bits looks wrong to me
> because the mask does not match the val.
> I don't have this hardware, can you test this patch?
> 
> Thanks,

The scale bits can be never updated without this patch.
This patch should be applied.

Thanks for fixing this bug !

Best Regards,
Milo



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
