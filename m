Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab0IHUgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:36:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:31166 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab0IHUgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:36:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,335,1280732400"; 
   d="scan'208";a="552783289"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kyle McMartin <kyle@mcmartin.ca>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-cris-kernel@axis.com" <linux-cris-kernel@axis.com>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Greg Ungerer <gerg@uclinux.org>, Jeff Dike <jdike@addtoit.com>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Date: Wed, 8 Sep 2010 13:36:24 -0700
Subject: RE: [RFC trollpatch 1/1] genirq: Remove the fits all and nothing
 __do_IRQ() code
Thread-Topic: [RFC trollpatch 1/1] genirq: Remove the fits all and nothing
 __do_IRQ() code
Thread-Index: ActPh9wEdUteUl91RKaXDji/8edtgQADVA7A
Message-ID: <987664A83D2D224EAE907B061CE93D53015DB0FB80@orsmsx505.amr.corp.intel.com>
References: <20100908152036.643594727@linutronix.de>
 <20100908185824.GD24791@bombadil.infradead.org>
In-Reply-To: <20100908185824.GD24791@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks Thomas for the reminder, I'll poke at fixing parisc this week,
> and maybe try to fix ia64 and alpha too as penance for forgetting about
> this for so long.

I'll be happy to see ia64 converted ... I did look at it once a long
time ago, but couldn't work out what I had to do to replace do_IRQ.
If Kyle figures out the patch, I'll test.  If not, then some pointers
would be helpful.

-Tony
