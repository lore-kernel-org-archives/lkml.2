Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1GZFvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:51:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:31547 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab1GZFu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:50:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,267,1309762800"; 
   d="scan'208";a="32299769"
Subject: Re: [PATCH v2 1/6] perf: Add interface to add general events to
 sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20110726044257.GB27720@suse.de>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	 <1310740503-15608-2-git-send-email-ming.m.lin@intel.com>
	 <1310996068.13765.67.camel@twins>
	 <1311581475.3938.1477.camel@minggr.sh.intel.com>
	 <1311582723.2617.50.camel@laptop> <20110725152038.GA23356@suse.de>
	 <1311642367.3938.1516.camel@minggr.sh.intel.com>
	 <20110726044257.GB27720@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 13:50:43 +0800
Message-ID: <1311659443.3938.1522.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 12:42 +0800, Greg KH wrote:
> On Tue, Jul 26, 2011 at 09:06:07AM +0800, Lin Ming wrote:
> > On Mon, 2011-07-25 at 23:20 +0800, Greg KH wrote:
> > > On Mon, Jul 25, 2011 at 10:32:03AM +0200, Peter Zijlstra wrote:
> > > > On Mon, 2011-07-25 at 16:11 +0800, Lin Ming wrote:
> > > > > It's strange that I didn't find a way to check if a directory is present
> > > > > in sysfs. Any hint?
> > > > 
> > > > sysfs is voodoo for me, best I can come up with is, ask the sysfs
> > > > folks ;-)
> > > > 
> > > > Kay, Greg?
> > > 
> > > What are you trying to do here specifically?
> > 
> > Now there are perf event source devices in sysfs.
> 
> As of what kernel release?

Since v2.6.38-rc1, commit abe4340(perf: Sysfs enumeration)

