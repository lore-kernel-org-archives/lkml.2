Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2AXXAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:00:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:7570 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab2AXXA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:00:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99334305"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v5 03/12] x86/topology.c: Support functions for CPU0
 online/offline
Thread-Topic: [PATCH v5 03/12] x86/topology.c: Support functions for CPU0
 online/offline
Thread-Index: AQHM0IXsBQT5wJDS+kaktsKKH5Ad3ZYPz3EAgAxdKjCAAI5JgP//elbQ
Date: Tue, 24 Jan 2012 23:00:25 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122003476A@ORSMSX105.amr.corp.intel.com>
References: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
	 <1326301493-28760-4-git-send-email-fenghua.yu@intel.com>
	 <1326735308.3065.29.camel@bwh-desktop>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122003473E@ORSMSX105.amr.corp.intel.com>
 <1327445577.2568.8.camel@bwh-desktop>
In-Reply-To: <1327445577.2568.8.camel@bwh-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0ON0a7R032299

> > Quote from https://www.linux.com/how-to-participate-in-the-linux-
> community
> > "It can be tempting to add a whole new infrastructure with a series
> of
> > patches, but to leave that infrastructure unused until the final
> patch
> > in the series enables the whole thing. This temptation should be
> > avoided if possible; if that series adds regressions, bisection will
> > finger the last patch as the one which caused the problem, even
> though
> > the real bug is elsewhere. Whenever possible, a patch which adds new
> > code should make that code active immediately."
> >
> > So this patch currently is in the right place in the patch set unless
> > I miss something.
> 
> You're giving undue weight to that guidance.  It is far more important
> that you do not enable features that don't work!

Either way has reasonable arguments. This should be a generic question. But for this specific patch set, the above quote does make more sense to me as far as git bisect is concerned. Maybe someone else in the list can provide more insight?

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
