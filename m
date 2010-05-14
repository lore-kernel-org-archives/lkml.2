Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0ENCFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:05:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:57668 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab0ENCFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:05:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="276968069"
Date: Fri, 14 May 2010 10:05:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Greg KH <gregkh@suse.de>, akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
Message-ID: <20100514020526.GB7678@localhost>
References: <20100513120016.GG2169@shaohui>
 <20100513165603.GC25212@suse.de>
 <20100514014902.GB4381@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514014902.GB4381@shaohui>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 09:49:02AM +0800, Zheng, Shaohui wrote:
> On Thu, May 13, 2010 at 09:56:03AM -0700, Greg KH wrote:
> > On Thu, May 13, 2010 at 08:00:16PM +0800, Shaohui Zheng wrote:
> > > hotplug emulator:extend memory probe interface to support NUMA
> > > 
> > > Extend memory probe interface to support an extra paramter nid,
> > > the reserved memory can be added into this node if node exists.
> > > 
> > > Add a memory section(128M) to node 3(boots with mem=1024m)
> > > 
> > > 	echo 0x40000000,3 > memory/probe
> > > 
> > > And more we make it friendly, it is possible to add memory to do
> > > 
> > > 	echo 3g > memory/probe
> > > 	echo 1024m,3 > memory/probe
> > > 
> > > It maintains backwards compatibility.
> > 
> > Again, please document this.
> > 
> > thanks,
> > 
> > greg k-h
> 
> okay

Shaohui, it's useless to document a wrong interface.
Better to fix the interface _first_, then document becomes meaningful.

Thanks,
Fengguang
