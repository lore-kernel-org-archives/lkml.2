Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2EWEkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:40:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:35824 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab2EWEkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:40:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="147253294"
Message-ID: <1337748069.14538.181.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH] ipv4: fix the rcu race between free_fib_info and
 ip_route_output_slow
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: kunx.jiang@intel.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 12:41:09 +0800
In-Reply-To: <20120522.234920.1047532847473945281.davem@davemloft.net>
References: <1337742123.14538.175.camel@ymzhang.sh.intel.com>
	 <20120522.232310.911242148705021745.davem@davemloft.net>
	 <1337743841.14538.178.camel@ymzhang.sh.intel.com>
	 <20120522.234920.1047532847473945281.davem@davemloft.net>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 23:49 -0400, David Miller wrote:
> From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Date: Wed, 23 May 2012 11:30:41 +0800
> 
> > How about the new patch posted in the end of previous reply? It does move the
> > the resetting to RCU release.
> > https://lkml.org/lkml/2012/5/22/558?
> 
> If you test it and submit it formally I'll probably apply it.
We did test it. But it's hard to reproduce it. We hit it the issue
for a couple of times when running MTBF testing on Android smart phone.
Mostly, it happens after MTBF runs for more than 12 hours. To releasing
the product, MTBF testing should run for hundreds of hours. This bug
blocks it.

We would submit it formally and also run more testing.

Sorry for taking you too much time.


