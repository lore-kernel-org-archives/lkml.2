Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2IZI41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:56:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:18932 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab2IZI4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:56:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,489,1344236400"; 
   d="scan'208";a="149210897"
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
Thread-Index: AQHNm8PwPUtQ4PG6tkCPeWV2SEPw4pecUZUg
Date: Wed, 26 Sep 2012 08:56:20 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A18A494@SHSMSX101.ccr.corp.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8Q8uWHc030623

> A return value of 0 and 1 are acceptable. So this check isn't correct.
> 
> Regards,
> Srivatsa S. Bhat
> 
Which case value 1 is acceptable, could you share? Thanks.

> OMG, why did you drop the other hunk which cleared the cpu *before*
> invoking ->irq_set_affinity()? IMO, altering irq affinity involves more work
> than just altering the mask; that's why you have that ->irq_set_affinity()
> function. So, if you alter the mask *after* calling ->irq_set_affinity(),
> its not right..
Sorry the mistake, will update.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
