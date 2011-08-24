Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1HXRuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:50:18 -0400
Received: from 64-198-47-7.ip.mcleodusa.net ([64.198.47.7]:30379 "EHLO
	mail02.indesign-llc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1HXRuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:50:16 -0400
From: "Barnes, Clifton A." <cabarnes@indesign-llc.com>
To: Axel Lin <axel.lin@gmail.com>
CC: Peter Edwards <sweetlilmre@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] power_supply: ds2780_battery/z2_battery: add
 __devexit_p at necessary places
Thread-Topic: [PATCH] power_supply: ds2780_battery/z2_battery: add
 __devexit_p at necessary places
Thread-Index: AQHMPKfueko2TP7hBUGn74rJ3C3Uw5Uskn6A
Date: Wed, 24 Aug 2011 17:50:08 +0000
Message-ID: <A8DC7EA93EFCBD4498E3857AFE65E5F1A5A2B9E8@IND07.indesign.net>
References: <1310044513.24314.1.camel@phoenix>
In-Reply-To: <1310044513.24314.1.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7OHoWpa001475

On Thursday, July 07, 2011 9:15 AM, Axel Lin wrote:

> According to the comments in include/linux/init.h:

> "Pointers to __devexit functions must use __devexit_p(function_name), the
> wrapper will insert either the function_name or NULL, depending on the config
> options."

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Checked out ok here for ds2780.

Acked-by: Clifton Barnes <cabarnes@indesign-llc.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
