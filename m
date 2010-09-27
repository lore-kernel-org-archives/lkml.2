Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab0I0TB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:01:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:23932 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933375Ab0I0TBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:01:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,244,1283756400"; 
   d="scan'208";a="841382294"
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-cris-kernel@axis.com" <linux-cris-kernel@axis.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Greg Ungerer <gerg@uclinux.org>, Jeff Dike <jdike@addtoit.com>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Date: Mon, 27 Sep 2010 12:01:51 -0700
Subject: RE: [RFC trollpatch 1/1] genirq: Remove the fits all and nothing
 __do_IRQ() code
Thread-Topic: [RFC trollpatch 1/1] genirq: Remove the fits all and nothing
 __do_IRQ() code
Thread-Index: ActedNyThmWIOFhLRrar/oa2Z2pp8gAAVRfQ
Message-ID: <987664A83D2D224EAE907B061CE93D530160471328@orsmsx505.amr.corp.intel.com>
References: <20100908152036.643594727@linutronix.de>
 <AANLkTikVHO9DmyTX==CwViDK1rP0masBwjMakHZ0U=kZ@mail.gmail.com>
 <alpine.LFD.2.00.1009271953390.2416@localhost6.localdomain6>
 <987664A83D2D224EAE907B061CE93D5301604712B4@orsmsx505.amr.corp.intel.com>
 <alpine.LFD.2.00.1009272048100.2416@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1009272048100.2416@localhost6.localdomain6>
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

>> handle_level_irq() works for my level triggered interrupts if I add
>> a "desc->chip->end(irq)" call to it.
>
> Hmm, why isn't chip->unmask() sufficient ?
 
That's a good question.  I'll take a look at what ia64 is doing
in the ->unmask() and ->end() functions to see if I can fix this
with some code shuffling.

Thanks

-Tony
