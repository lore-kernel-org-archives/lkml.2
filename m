Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1HXUrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:47:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:33504 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1HXUrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:47:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,277,1312182000"; 
   d="scan'208";a="44038193"
From: "Luck, Tony" <tony.luck@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ken Chen <kenchen@google.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>
Date: Wed, 24 Aug 2011 13:46:58 -0700
Subject: RE: [ia64] Question on __ARCH_WANT_UNLOCKED_CTXSW
Thread-Topic: [ia64] Question on __ARCH_WANT_UNLOCKED_CTXSW
Thread-Index: AcxiWSz0iM4nQKhhTRa7ssSjbVsI5gARQtZQ
Message-ID: <987664A83D2D224EAE907B061CE93D5301EA611910@orsmsx505.amr.corp.intel.com>
References: <1314188833.6925.3.camel@twins>
In-Reply-To: <1314188833.6925.3.camel@twins>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7OKlDVH002408

> happen to remember what the perceived benefit of using
> __ARCH_WANT_UNLOCKED_CTXSW was about?

No - digging around the code hasn't rung any bells for me either.

Perhaps just general goodness for not holding a lock for
longer than we need to?  But that would imply some case where
someone else could do something useful by being able to grab
the lock when we drop it. About the only thing I can think
of is that it would allow tasks to be re-balanced just a
teeny bit earlier --- but re-balancing ought to be somewhat
rare, yes?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
