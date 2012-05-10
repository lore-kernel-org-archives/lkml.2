Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab2EJUsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:48:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:1632 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756938Ab2EJUsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:48:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151569350"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Subject: RE: [PATCH v6 07/12] x86/head_32.S: Define start_cpu0
Thread-Topic: [PATCH v6 07/12] x86/head_32.S: Define start_cpu0
Thread-Index: AQHNLsntvr1l3h/gokGh24+5F7dfwZbDvSMA//+mgrA=
Date: Thu, 10 May 2012 20:48:38 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122007715B10@ORSMSX105.amr.corp.intel.com>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
 <1336666614-21090-8-git-send-email-fenghua.yu@intel.com>
 <878ae68a-72cf-40cb-a654-a2c1cb3df0c3@email.android.com>
In-Reply-To: <878ae68a-72cf-40cb-a654-a2c1cb3df0c3@email.android.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4AKmlZD014323

> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Thursday, May 10, 2012 10:31 AM
> To: Yu, Fenghua; Ingo Molnar; Thomas Gleixner; Linus Torvalds; Andrew
> Morton; Mallick, Asit K; Luck, Tony; Arjan Dan De Ven; Siddha, Suresh B;
> Brown, Len; Srivatssa S. Bhat; Randy Dunlap; Chen Gong; linux-kernel;
> linux-pm; x86
> Subject: Re: [PATCH v6 07/12] x86/head_32.S: Define start_cpu0
> 
> Can you check how this interacts with tip:x86/realmode?

When CPU0 is waken up by NMI, it's in protect mode and jumps to start_cpu0() which only sets up stack and goes to initial_code. CPU0 wake up doesn't go through trampline and starts from real mode. This is different from waking up AP when AP goes through INIT/STARTUP sequence and starts from real mode.

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
