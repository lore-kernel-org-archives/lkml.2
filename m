Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab0GVLV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:21:27 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:42561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab0GVLV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:21:26 -0400
Subject: Re: [RFC][PATCH v1 06/15] perf: export tracepoint events via
 sysfs: iwlwifi and iwlwifi_io
From: Johannes Berg <johannes@sipsolutions.net>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Reinette Chatre <reinette.chatre@intel.com>,
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
In-Reply-To: <1279797230.20942.87.camel@minggr.sh.intel.com>
References: <1279797230.20942.87.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 13:20:40 +0200
Message-ID: <1279797640.12439.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 19:13 +0800, Lin Ming wrote:
> iwlwifi and iwlwifi_io tracepoint events are exported like below,

>  drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)

err, how about iwlagn?

johannes

