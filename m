Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1IBRkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:40:01 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:6376 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1IBRkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:40:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1314984593!17195653!635
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 2 Sep 2011 12:32:47 -0500
Subject: gpio-ep93xx patches
Thread-Topic: gpio-ep93xx patches
Thread-Index: AcxpllTp6bA5Yx6ST7KZpJNiu3b30g==
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39D7486FA@AUSP01VMBX24.collaborationhost.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p82HeCXs014770

Hello Grant,

I posted two patches for gpio-ep93xx.c around the beginning of August.

	gpio: ep93xx: remove unused inline function
	gpio: ep93xx: remove useless pr_err message

Did you get a chance to looks at them?

I have a pending patch to convert the gpio-ep93xx interrupt support to
use irq_generic_chip but would like those to go in first if possible.

Thanks,
Hartleyÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
