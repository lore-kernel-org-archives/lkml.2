Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935130Ab1JETWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:22:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:51011 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934402Ab1JETWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:22:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="60267457"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 5 Oct 2011 12:22:32 -0700
Subject: RE: [PATCH 0/8] Online/offline BSP on x86
Thread-Topic: [PATCH 0/8] Online/offline BSP on x86
Thread-Index: AcyDk1Xo75TKZaOlQcCxaVp4209qrwAAFMAQ
Message-ID: <493994B35A117E4F832F97C4719C4C040136F7CC16@orsmsx505.amr.corp.intel.com>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com>
 <1317842195.6766.40.camel@twins>
In-Reply-To: <1317842195.6766.40.camel@twins>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id p95JMtd9029506



> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, October 05, 2011 12:17 PM
> To: Yu, Fenghua
> Cc: Ingo Molnar; Thomas Gleixner; H Peter Anvin; Zwane Mwaikambo; Luck,
> Tony; Mallick, Asit K; Siddha, Suresh B; Len Brown; linux-kernel
> Subject: Re: [PATCH 0/8] Online/offline BSP on x86
> 
> On Wed, 2011-10-05 at 09:39 -0700, Fenghua Yu wrote:
> >
> > BSP or CPU0 has been the last obstacle to CPU hotplug on x86. This
> patch set
> > implements BSP online and offline and removes this obstacle to CPU
> hotplug.
> 
> Are you talking about physical cpu hotplug on x86? And you need to
> offline the BSP so you can replace socket0 ?


This patch set is for BSP online/offline.

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
