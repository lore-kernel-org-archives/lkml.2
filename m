Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab0ETUI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:08:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44626 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab0ETUI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:08:57 -0400
Subject: Re: [RFC][PATCH v2 11/11] perf top: demo of how to use the sysfs
 interface
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4BF4915B.10104@linux.vnet.ibm.com>
References: <1274233792.3036.90.camel@localhost>
	 <4BF42B6F.6000009@linux.vnet.ibm.com>
	 <1274318249.3603.135.camel@minggr.sh.intel.com>
	 <4BF4915B.10104@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 22:08:46 +0200
Message-ID: <1274386126.1674.1637.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 18:33 -0700, Corey Ashford wrote:
> 
> We also need to take into account event "attributes" - other data that
> is needed to configure a specific event.  For example, think about a
> memory controller which has a PMU can count events in a particular
> memory range; we need to be able to supply the memory range somehow, 

That's that perf_event_attr is for.

