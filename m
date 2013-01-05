Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3AEJ73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 04:59:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:30145 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414Ab3AEJ70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 04:59:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,415,1355126400"; 
   d="scan'208";a="240256633"
From: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7u1 06/31] x86, 64bit, realmode: use init_level4_pgt to
 set trapmoline_pgt directly
Thread-Topic: [PATCH v7u1 06/31] x86, 64bit, realmode: use init_level4_pgt
 to set trapmoline_pgt directly
Thread-Index: AQHN6hVnL146f94eBke+cgM6IRM815g5awmAgABO9ACAAMiVgA==
Date: Sat, 5 Jan 2013 09:59:02 +0000
Message-ID: <1357379977.20394.7.camel@jsakkine-mobl1>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	 <1357260531-11115-7-git-send-email-yinghai@kernel.org>
	 <1357319947.7763.1.camel@jsakkine-mobl1>
	 <CAE9FiQU4ZZJkHbVy-RFkY_P10RyQ6LREYz7B=w4hR=u3J+iQbg@mail.gmail.com>
In-Reply-To: <CAE9FiQU4ZZJkHbVy-RFkY_P10RyQ6LREYz7B=w4hR=u3J+iQbg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.14.26]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0517CF42F016C3468F0610E31C341F9C@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r059xV5X018327

On Fri, 2013-01-04 at 14:01 -0800, Yinghai Lu wrote:
> On Fri, Jan 4, 2013 at 9:18 AM, Sakkinen, Jarkko
> <jarkko.sakkinen@intel.com> wrote:
> > On Thu, 2013-01-03 at 16:48 -0800, Yinghai Lu wrote:
> >> with #PF handler way to set early page table, level3_ident will go away with
> >> 64bit native path.
> >>
> >> So just use entries in init_level4_pgt to set them in tramopline_pgt
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> >
> > Acked-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> 
> Thanks.
> 
> updated the patch, and would save some time for HPA.

Sure. They look fine to me. Larger patch does only code
reordering from realmode code point of view and smaller 
patch initializes trampoline_gdt essentially with the 
same values as before so I don't see why these patches 
would break anything.

But let's wait for hpa comments.

/Jarkko
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
