Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab1FQUF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 16:05:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:28564 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932949Ab1FQUF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 16:05:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,382,1304319600"; 
   d="scan'208";a="16355933"
Date: Fri, 17 Jun 2011 13:04:34 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "Luck, Tony" <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] mm, memory-failure: Fix spinlock vs mutex order
Message-ID: <20110617200434.GC28954@tassilo.jf.intel.com>
References: <BANLkTim-dBjva9w7AajqggKT3iUVYG2euQ@mail.gmail.com>
 <BANLkTimLV8aCZ7snXT_Do+f4vRY0EkoS4A@mail.gmail.com>
 <BANLkTinUBTYWxrF5TCuDSQuFUAyivXJXjQ@mail.gmail.com>
 <1308310080.2355.19.camel@twins>
 <BANLkTim2bmPfeRT1tS7hx2Z85QHjPHwU3Q@mail.gmail.com>
 <alpine.LSU.2.00.1106171040460.7018@sister.anvils>
 <BANLkTim3vo0vpovV=5sU=GLxkotheB=Ryg@mail.gmail.com>
 <1308334688.12801.19.camel@laptop>
 <1308335557.12801.24.camel@laptop>
 <1308340385.12801.101.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308340385.12801.101.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought about maybe using rcu, but then thought the thing is probably
> wanting to exclude new tasks as it wants to kill all mm users.

Probably both would work.

Looks good to me.  hwpoison patches are usually directly merged by Andrew 
these days.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi

