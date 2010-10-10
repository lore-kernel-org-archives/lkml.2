Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab0JJBEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 21:04:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:65442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab0JJBEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 21:04:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,309,1283756400"; 
   d="scan'208";a="665844789"
From: "Anvin, H Peter" <h.peter.anvin@intel.com>
To: "'torvalds@linux-foundation.org'" <torvalds@linux-foundation.org>,
        "'yinghai@kernel.org'" <yinghai@kernel.org>
CC: "'holt@sgi.com'" <holt@sgi.com>, "'rja@sgi.com'" <rja@sgi.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'tglx@linutronix.de'" <tglx@linutronix.de>,
        "'steiner@sgi.com'" <steiner@sgi.com>,
        "'mingo@elte.hu'" <mingo@elte.hu>
Date: Sat, 9 Oct 2010 18:04:13 -0700
Subject: RE: [BUG] x86: bootmem broken on SGI UV
Thread-Topic: [BUG] x86: bootmem broken on SGI UV
Thread-Index: Actn4VviPx6W9NI+Tf6w8PI9jZ2h2wANbHqv
Message-ID: <ADDEBCD9C145E542A8688C29F1FBDCB9C4B1765D@orsmsx502.amr.corp.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9A14R6d009502

We'll have it for you before then; one way or other (I'm away for the weekend, but will be back tomorrow evening.)

-- 
Sent from my mobile phone; pardon the brevity and lack of formatting.


 -----Original Message-----
From: 	Linus Torvalds [mailto:torvalds@linux-foundation.org]
Sent:	Saturday, October 09, 2010 11:39 AM Pacific Standard Time
To:	Yinghai Lu
Cc:	Robin Holt; Russ Anderson; linux-kernel; tglx@linutronix.de; Anvin, H Peter; Jack Steiner; Ingo Molnar
Subject:	Re: [BUG] x86: bootmem broken on SGI UV

On Sat, Oct 9, 2010 at 11:06 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> It is too late for put in 2.6.36. Linus already had -rc7, and assume he will have final .36 this week.

Anything that is worth tagging for stable is worth fixing before the
final release (probably Wednesday).

But I do want it tested and confirmed, and acked by lots of people.
And preferably get it through the normal channels too.

                    Linus
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
