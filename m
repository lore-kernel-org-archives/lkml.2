Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab2GDNaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 09:30:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:4133 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2GDNaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:30:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="161353424"
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
Thread-Index: AQHNWegxNurOYIWfgUuAR26n58tdbpcZHgAw
Date: Wed, 4 Jul 2012 13:30:10 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A10C84B@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A10C7F6@SHSMSX101.ccr.corp.intel.com>
 <1341408169.2507.111.camel@laptop>
In-Reply-To: <1341408169.2507.111.camel@laptop>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q64DULko022998

> Yuck.. and no. This makes sane things like early 8250 serial console less
> reliable.
Peter, could you share more? I took many time to dig out this issue.
Anyway, in nmi handler, calling printk is dangerous. This patch is for this case.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
