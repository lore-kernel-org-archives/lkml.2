Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0ENCPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:15:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:33780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab0ENCPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:15:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="621559642"
Date: Fri, 14 May 2010 10:11:29 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg KH <gregkh@suse.de>, akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, ak@linux.intel.com,
       haicheng.li@linux.intel.com, shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 3/7] NUMA hotplug emulator
Message-ID: <20100514021129.GE4381@shaohui>
Mail-Followup-To: Wu Fengguang <fengguang.wu@intel.com>,
	Greg KH <gregkh@suse.de>, akpm@linux-foundation.org,
	linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
	linux-kernel@vger.kernel.org, ak@linux.intel.com,
	haicheng.li@linux.intel.com, shaohui.zheng@linux.intel.com
References: <20100513114835.GD2169@shaohui>
 <20100513165511.GB25212@suse.de>
 <20100514014535.GA4381@shaohui>
 <20100514020135.GA7678@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514020135.GA7678@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 10:01:35AM +0800, Wu Fengguang wrote:
> On Fri, May 14, 2010 at 09:45:35AM +0800, Zheng, Shaohui wrote:
> > On Thu, May 13, 2010 at 09:55:11AM -0700, Greg KH wrote:
> > > On Thu, May 13, 2010 at 07:48:35PM +0800, Shaohui Zheng wrote:
> > > > Userland interface to hotplug-add fake offlined nodes.
> > > 
> > > Why include 2 copies of the patch in one email?
> > I always try to attach the patch as attachment, it is the same with the mail
> > content, I guess it should take convenience when you need to save the patch 
> > to local, it might be a bad habbit, I will be careful when I send patch next time.
> > thanks for the reminding.
> 
> Shaohui, git/quilt are great tools for submitting patch series.
Thanks fengguang, I am the new fish in LKML, so I send the patches manually one by
one, I will try this tool next time.

> 
> > > 
> > > > Add a sysfs entry "probe" under /sys/devices/system/node/:
> > > > 
> > > >  - to show all fake offlined nodes:
> > > >     $ cat /sys/devices/system/node/probe
> > > > 
> > > >  - to hotadd a fake offlined node, e.g. nodeid is N:
> > > >     $ echo N > /sys/devices/system/node/probe
> > > 
> > > As you are trying to add a new sysfs file, please create the matching
> > > Documentation/ABI/ file as well.
> > 
> > Agree, We will document it in.
> > 
> > > 
> > > Also note that sysfs files are "one value per file", which I don't think
> > > this file follows, right?
> > 
> > Agree, the cpu/probe interface should write only, and we should create another
> > file to indicate the hidden nodes, such as cpu/hidden. We will follow this rule
> > when we send the formal patch.
> 
> I'd prefer to avoid new interfaces if not absolutely necessary.
> 
> Thanks,
> Fengguang

-- 
Thanks & Regards,
Shaohui

