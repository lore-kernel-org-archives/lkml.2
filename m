Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab0GWAxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 20:53:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:36128 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808Ab0GWAxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 20:53:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,245,1278313200"; 
   d="scan'208";a="820793590"
Subject: Re: [RFC][PATCH v1 06/15] perf: export tracepoint events via
 sysfs: iwlwifi and iwlwifi_io
From: Lin Ming <ming.m.lin@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
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
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1279797640.12439.11.camel@jlt3.sipsolutions.net>
References: <1279797230.20942.87.camel@minggr.sh.intel.com>
	 <1279797640.12439.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 08:53:52 +0800
Message-ID: <1279846432.23266.1.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 19:20 +0800, Johannes Berg wrote:
> On Thu, 2010-07-22 at 19:13 +0800, Lin Ming wrote:
> > iwlwifi and iwlwifi_io tracepoint events are exported like below,
> 
> >  drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +++++++++++++++
> >  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> err, how about iwlagn?

Will add this.

> 
> johannes
> 


