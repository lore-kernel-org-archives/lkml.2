Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2IZIm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:42:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:26001 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab2IZImx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:42:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,489,1344236400"; 
   d="scan'208";a="197824173"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: RE: [PATCH] x86/fixup_irq: Clean the offlining CPU from the irq
 affinity mask
Thread-Topic: [PATCH] x86/fixup_irq: Clean the offlining CPU from the irq
 affinity mask
Thread-Index: AQHNm8DvhYsY0RaPTk+cXNL7z+T1PZecTcXQ
Date: Wed, 26 Sep 2012 08:41:40 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A18A3F4@SHSMSX101.ccr.corp.intel.com>
References: <1348669924.19514.6.camel@cliu38-desktop-build>
 <5062A442.2030207@linux.vnet.ibm.com>
 <27240C0AC20F114CBF8149A2696CBE4A189F97@SHSMSX101.ccr.corp.intel.com>
 <5062B602.6000502@linux.vnet.ibm.com>
 <27240C0AC20F114CBF8149A2696CBE4A18A2E4@SHSMSX101.ccr.corp.intel.com>
 <5062BC7A.8020002@linux.vnet.ibm.com>
In-Reply-To: <5062BC7A.8020002@linux.vnet.ibm.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8Q8h1OT030415

> I know.. What I meant is, the code warns only if chip->irq_set_affinity
> is NULL and doesn't care if chip->irq_set_affinity was not NULL and
> the function failed to set the affinity (ie., when chip->irq_set_affinity()
> returns error). In other words, I meant to say that this is one more
> case where we need to warn about our failure to set the irq affinity.
> 
Got it, has resent the patch to include it, thanks your review.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
