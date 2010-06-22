Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab0FVHxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 03:53:03 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:57574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab0FVHxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 03:53:00 -0400
Subject: Re: [rfc] Describe events in a structured way via sysfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Greg KH <greg@kroah.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1277192877.5025.9.camel@minggr.sh.intel.com>
References: <1274233602.3036.84.camel@localhost>
	 <20100518200524.GA20223@kroah.com>
	 <1274236496.3603.22.camel@minggr.sh.intel.com>
	 <20100519024823.GA25229@kroah.com>	<1274253276.5605.10124.camel@twins>
	 <20100520184213.GB21030@kroah.com>	<20100520201418.GB11470@elte.hu>
	 <20100520231229.GB8335@kroah.com>	<1274429038.1674.1684.camel@laptop>
	 <20100521094053.GA4658@elte.hu>
	 <AANLkTimf1Z0N9cv2Pu2qTTUscn4utC37zOPelCbqQoPv@mail.gmail.com>
	 <1277110509.18390.28.camel@minggr.sh.intel.com>
	 <1277112858.3618.16.camel@jlt3.sipsolutions.net>
	 <1277187920.4467.3.camel@minggr.sh.intel.com>
	 <1277189971.3637.5.camel@jlt3.sipsolutions.net>
	 <1277191359.5025.4.camel@minggr.sh.intel.com>
	 <1277192007.3637.8.camel@jlt3.sipsolutions.net>
	 <1277192877.5025.9.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 09:52:25 +0200
Message-ID: <1277193145.3637.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 15:47 +0800, Lin Ming wrote:

> So it can only trace the whole hardware piece rather than a specific
> interface?
> 
> If yes, then will change to
> - /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0/events/iwlwifi_dev_ioread32/
> + /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/events/iwlwifi_dev_ioread32/

Yes, I guess you were right from the start and I was just thinking about
it the wrong way. So presumably you'll somehow have to "instantiate"
tracepoints for a given device?

johannes

