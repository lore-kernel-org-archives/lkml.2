Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab2ILBTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:19:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:53584 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab2ILBTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:19:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,407,1344236400"; 
   d="scan'208";a="220972137"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Andy Whitcroft <apw@canonical.com>, David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH] checkpatch: Check networking specific block comment
 style
Thread-Topic: [PATCH] checkpatch: Check networking specific block comment
 style
Thread-Index: AQHNkIBUJ3iozheCikaYIDc4eKJJG5eF4vlA
Date: Wed, 12 Sep 2012 01:19:51 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A1842EB021D9@ORSMSX102.amr.corp.intel.com>
References: <1347410853.2456.7.camel@joe2Laptop>
In-Reply-To: <1347410853.2456.7.camel@joe2Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8C1JwWq026855

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Joe Perches
> Sent: Tuesday, September 11, 2012 5:48 PM
> To: Andrew Morton
> Cc: Andy Whitcroft; David Miller; LKML; netdev
> Subject: [PATCH] checkpatch: Check networking specific block comment
> style
> 
> In an effort to get fewer checkpatch reviewer corrections,
> add a networking specific style test for the preferred
> networking comment style.
> 
> 	/* The preferred style for block comments in
> 	 * drivers/net/... and net/... is like this
> 	 */
> 
> These tests are only used in net/ and drivers/net/
> 
> Tested with:
> 
> $ cat drivers/net/t.c
> 
> /* foo */
> 
> /*
>  * foo
>  */
> 
> /* foo
>  */
> 
> /* foo
>  * bar */
> $ ./scripts/checkpatch.pl -f drivers/net/t.c
> WARNING: networking block comments don't use an empty /* line, use /* Comment...

This conflicts with the preferred style for long (multi-line) comments documented in
./Documentation/CodingStyle.  If this is the way comments should be done in the
networking code this patch should also include an update to Chapter 8 in CodingStyle
documenting the networking specific style to avoid confusion.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
