Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192Ab2HXTxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:53:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:52859 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760132Ab2HXTxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:53:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="scan'208";a="213607454"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v7 02/12] x86/Kconfig: Add config switch for CPU0 hotplug
Thread-Topic: [PATCH v7 02/12] x86/Kconfig: Add config switch for CPU0
 hotplug
Thread-Index: AQHNgZVV6EYR2RB16UmEwtme5YqL9pdpKYcAgAAz7/A=
Date: Fri, 24 Aug 2012 19:53:31 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122007789378@ORSMSX105.amr.corp.intel.com>
References: <1345769771-27019-1-git-send-email-fenghua.yu@intel.com>
 <1345769771-27019-3-git-send-email-fenghua.yu@intel.com>
 <20120824093436.GC3019@liondog.tnic>
In-Reply-To: <20120824093436.GC3019@liondog.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7OJrx57005002

> And, btw, maybe I didn't catch this earlier, but why is in all
> user-visible options the thing called "cpu0_*"? Wouldn't it be better
> to
> call it "bsp_*"?

The kernel parameter was called bsp_hotplug before. It was changed to cpu0_hotplug in v5 to keep uniform cpu0/CPU0 names.

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
