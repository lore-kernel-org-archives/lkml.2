Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2GDOS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:18:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:62245 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2GDOSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:18:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163997701"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: RE: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
Thread-Topic: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
Thread-Index: AQHNWe6l5Ig/NPsiekGPtOROVAU1P5cYpDeAgACHgdA=
Date: Wed, 4 Jul 2012 14:18:51 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A10C9C5@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A10C7F6@SHSMSX101.ccr.corp.intel.com>
	 <1341408169.2507.111.camel@laptop>
	 <27240C0AC20F114CBF8149A2696CBE4A10C84B@SHSMSX101.ccr.corp.intel.com>
	 <1341409177.2507.117.camel@laptop>  <1341410957.2507.120.camel@laptop>
 <1341411171.2507.123.camel@laptop>
In-Reply-To: <1341411171.2507.123.camel@laptop>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q64EJ1ac023210

> Note that the one 'down' side of this is that the folks who care about logbuf
> content might get upset since we don't put all msgs in there anymore.
Got it, thanks your correction.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
