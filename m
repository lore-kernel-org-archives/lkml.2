Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2IZIXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:23:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:45250 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab2IZIXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:23:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,489,1344236400"; 
   d="scan'208";a="226902096"
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
Thread-Index: AQHNm70SsGDPqcfIUU+NDp7I0s9XrJecSAKg
Date: Wed, 26 Sep 2012 08:23:42 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A18A318@SHSMSX101.ccr.corp.intel.com>
References: <1348669924.19514.6.camel@cliu38-desktop-build>
 <5062A442.2030207@linux.vnet.ibm.com>
 <27240C0AC20F114CBF8149A2696CBE4A189F97@SHSMSX101.ccr.corp.intel.com>
 <5062B602.6000502@linux.vnet.ibm.com>
In-Reply-To: <5062B602.6000502@linux.vnet.ibm.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8Q8OLUx030372

> In that case, we would end up with an incorrect data->affinity right?
> 
Moving the clean cpu mask code into if (chip->irq_set_affinity)?
Will resend the patch and will judge the chip->irq_set_affinity(data, affinity, true)
return value.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
