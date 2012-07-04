Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab2GDOqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:46:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:33533 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab2GDOqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:46:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118866006"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: RE: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
Thread-Topic: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
Thread-Index: AQHNWep8dTlvmJZVHkyvrH8TkPRqzpcZMyZg
Date: Wed, 4 Jul 2012 14:46:41 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A10CA93@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A10C7F6@SHSMSX101.ccr.corp.intel.com>
	 <1341408169.2507.111.camel@laptop>
	 <27240C0AC20F114CBF8149A2696CBE4A10C84B@SHSMSX101.ccr.corp.intel.com>
 <1341409177.2507.117.camel@laptop>
In-Reply-To: <1341409177.2507.117.camel@laptop>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q64El6nM023450

> > I took many time to dig out this issue.
> 
> Well, it was a known issue..
Still feel unfair :)
If this is a known issue that calling printk is not safe in nmi handler,
Why not defense it like this patch before real solution coming out?
Thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
