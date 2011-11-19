Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab1KSAvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:51:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:13890 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab1KSAvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:51:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="77535117"
From: "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
To: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
Date: Fri, 18 Nov 2011 16:51:20 -0800
Subject: RE: [patch 3/6] sched: use rq->avg_event to resurrect nohz
 ratelimiting
Thread-Topic: [patch 3/6] sched: use rq->avg_event to resurrect nohz
 ratelimiting
Thread-Index: AcymGYUt/budFY6cSs6Kyfzl9orElwAO8Vdg
Message-ID: <26E9B811E137AB4B95200FD4C950886BFF9781E8@orsmsx507.amr.corp.intel.com>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1321629562.7080.17.camel@marge.simson.net>
	 <1321630619.2197.16.camel@twins> <1321638146.6238.20.camel@marge.simson.net>
In-Reply-To: <1321638146.6238.20.camel@marge.simson.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAJ0pVvG014322

> > Arjan, can we do something smart with the idle governor which already
> > guestimates the idle duration for us?
> 
> That would be great.  Won't help my Intel Q6600 though, the intel_idle
> governor doesn't support it.  Other idle_governor gizmos really need to
> get smarter too.


you're confusing the governor (menu) and the low level hardware driver.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
