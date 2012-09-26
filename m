Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab2IZIvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:51:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:6907 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab2IZIvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,489,1344236400"; 
   d="scan'208";a="197269377"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: RE: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the
 irq affinity mask
Thread-Topic: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the
 irq affinity mask
Thread-Index: AQHNm8PwPUtQ4PG6tkCPeWV2SEPw4pecUH3A
Date: Wed, 26 Sep 2012 08:51:34 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A18A467@SHSMSX101.ccr.corp.intel.com>
References: <1348681092.19514.10.camel@cliu38-desktop-build>
 <5062C183.20301@linux.vnet.ibm.com>
In-Reply-To: <5062C183.20301@linux.vnet.ibm.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8Q8qBg9030517

> Please hold on.. I'm not yet done reviewing, I might have more comments :-)
Sure, welcome, thanks again.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
