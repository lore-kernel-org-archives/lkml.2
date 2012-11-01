Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab2KADOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 23:14:31 -0400
Received: from tw-mx2.synaptics.com.tw ([203.163.83.68]:58859 "EHLO
	tw-mx2.synaptics.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab2KADO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 23:14:29 -0400
From: Alexandra Chin <alexandra.chin@tw.synaptics.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: RE: [PATCH] staging: ste_rmi4: Convert to Type-B support
Thread-Topic: [PATCH] staging: ste_rmi4: Convert to Type-B support
Thread-Index: AQHNt0iaVH28WIkHEkKTYbYZL4AhCZfTOqSAgAELgJA=
Date: Thu, 1 Nov 2012 03:14:10 +0000
Message-ID: <CC51EC7B5B7F984AA566DC102237848896F5F362@hkdcw-mail1.synaptics-inc.local>
References: <CC51EC7B5B7F984AA566DC102237848896F590C0@hkdcw-mail1.synaptics-inc.local>
 <20121003180121.GA4198@polaris.bitmath.org>
 <CC51EC7B5B7F984AA566DC102237848896F5F20B@hkdcw-mail1.synaptics-inc.local>
 <20121031184347.GA1530@polaris.bitmath.org>
In-Reply-To: <20121031184347.GA1530@polaris.bitmath.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-HK
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.51.94]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA13Eg1o022774

Hi Henrik,

I see what you mean. Input subsystem handles multi-touch tracking for input driver.
I will update reporting process, and resubmit a patch against 3.7-rcX.
Greatly appreciate your comments.

Alexandra Chin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
