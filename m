Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab1FPWrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 18:47:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:18377 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522Ab1FPWrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 18:47:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,377,1304319600"; 
   d="scan'208";a="15933302"
Message-ID: <4DFA8802.6010300@linux.intel.com>
Date: Thu, 16 Jun 2011 15:47:30 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, shaohua.li@intel.com,
        alex.shi@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT PULL] Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
References: <1308097798.17300.142.camel@schen9-DESK> <1308134200.15315.32.camel@twins> <1308135495.15315.38.camel@twins> <BANLkTikt88KnxTy8TuGGVrBVnXvsnL7nMQ@mail.gmail.com> <20110615201216.GA4762@elte.hu> <35c0ff16-bd58-4b9c-9d9f-d1a4df2ae7b9@email.android.com> <20110616070335.GA7661@elte.hu> <20110616171644.GK2582@linux.vnet.ibm.com> <20110616202550.GA16214@elte.hu> <1308262883.2516.71.camel@pasglop> <20110616223837.GA18431@elte.hu>
In-Reply-To: <20110616223837.GA18431@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> There's a crazy solution for that: the idle thread could process RCU
> callbacks carefully, as if it was running user-space code.

In Ben's kernel NFS server case the system may not be idle.

-Andi


