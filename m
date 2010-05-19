Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0ESCin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:38:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:39022 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab0ESCim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:38:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,259,1272870000"; 
   d="scan'208";a="622857266"
Subject: Re: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100518200730.GB20223@kroah.com>
References: <1274233602.3036.84.camel@localhost>
	 <20100518200730.GB20223@kroah.com>
Content-Type: text/plain
Date: Wed, 19 May 2010 10:37:52 +0800
Message-Id: <1274236672.3603.24.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 04:07 +0800, Greg KH wrote:
> On Wed, May 19, 2010 at 01:46:42AM +0000, Lin Ming wrote:
> > +struct kobj_type event_ktype = {
> > +	.sysfs_ops	= &event_sysfs_ops,
> > +};
> 
> No release function?  Hm, are you setting yourself up to be publically
> made fun of?  You have read the kobject documentation about this, right?
> Have you looked at the kernel logs for when you try to free this object?

Ah, will fix this "fun".

> 
> thanks,
> 
> greg k-h

