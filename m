Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab0FVHYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 03:24:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:56880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab0FVHYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 03:24:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,459,1272870000"; 
   d="scan'208";a="529061127"
Subject: Re: [rfc] Describe events in a structured way via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
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
In-Reply-To: <1277189971.3637.5.camel@jlt3.sipsolutions.net>
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
Content-Type: text/plain
Date: Tue, 22 Jun 2010 15:22:39 +0800
Message-Id: <1277191359.5025.4.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 14:59 +0800, Johannes Berg wrote:
> On Tue, 2010-06-22 at 14:25 +0800, Lin Ming wrote:
> > On Mon, 2010-06-21 at 17:34 +0800, Johannes Berg wrote:
> > > On Mon, 2010-06-21 at 16:55 +0800, Lin Ming wrote:
> > > 
> > > > 21. iwlwifi_io events
> > > > /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0/events/iwlwifi_dev_ioread32/
> > > > ...
> > > > /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0/events/iwlwifi_dev_ucode_event/
> > > 
> > > 
> > > That doesn't work, you could have multiple PCI devices in your system.
> > 
> > Understood. This is just a "demo".
> > 
> > Actually, I mean
> > 
> > net/wlan0/events/
> > net/waln1/events/
> > ....
> > net/walnN/events/
> 
> That's not appropriate either though since you may have multiple network
> interfaces on the same hardware :)

Doesn't net/wlan0...wlanN mean multiple network interfaces on the same
hardware?

If my understanding is wrong, would you show me an example in sysfs?

> 
> > > > 23. skb events
> > > > /sys/class/net/events/kfree_skb/
> > > > /sys/class/net/events/skb_copy_datagram_iovec/
> > > 
> > > > 25. mac80211 events
> > > > /sys/class/net/events/drv_start/
> > > > ...
> > > > /sys/class/net/events/stop_queue
> > > 
> > > It doesn't really seem right to mix all these.
> > 
> > Well, agree, skb events are totally different with mac80211 events.
> > Any idea?
> 
> I suppose the most appropriate thing would
> be /sys/class/ieee80211/phyN/events/... for almost all of them.

Good idea.

Thanks,
Lin Ming

> 
> johannes
> 

