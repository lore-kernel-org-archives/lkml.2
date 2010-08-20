Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0HTPGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab0HTPGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:06:06 -0400
Date: Fri, 20 Aug 2010 11:05:42 -0400
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7KF6JPg030973

I'll test tip later today to see if I can reproduce it.

Cheers,
Don

Ingo Molnar <mingo@elte.hu> wrote:

>
>it's not working so well, i'm getting:
>
> Uhhuh. NMI received for unknown reason 00 on CPU 9.
> Do you have a strange power saving mode enabled?
> Dazed and confused, but trying to continue
>
>on a nehalem box, after a perf top and perf stat run.
>
>Thanks,
>
>	Ingo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
