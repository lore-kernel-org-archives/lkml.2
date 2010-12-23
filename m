Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab0LWFyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 00:54:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:9336 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0LWFyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 00:54:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,217,1291622400"; 
   d="scan'208";a="365656040"
Date: Thu, 23 Dec 2010 12:30:15 +0800
From: Shaohui Zheng <shaohui.zheng@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shaohui.zheng@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, lethal@linux-sh.org, ak@linux.intel.com,
        rientjes@google.com, dave@linux.vnet.ibm.com, gregkh@suse.de,
        Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        Yinghai Lu <Yinghai.Lu@Sun.COM>, Tejun Heo <tj@kernel.org>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [5/7, v9] NUMA Hotplug Emulator: Support cpu probe/release in
 x86_64
Message-ID: <20101223043015.GA13976@shaohui>
References: <20101210073119.156388875@intel.com>
 <20101210073242.670777298@intel.com>
 <20101222162727.56b830b0.akpm@linux-foundation.org>
 <20101223013410.GA11356@shaohui>
 <20101222192118.2d286ca9.akpm@linux-foundation.org>
 <20101223022428.GB12333@shaohui>
 <20101222212804.a164f488.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101222212804.a164f488.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 09:28:04PM -0800, Andrew Morton wrote:
> On Thu, 23 Dec 2010 10:24:28 +0800 Shaohui Zheng <shaohui.zheng@linux.intel.com> wrote:
> 
> > > 
> > > Why *does* it check `count' and then not use it?
> > > 
> > 
> > it is a tricky thing. When I debug it under a Virtual Machine, If I do a cpu
> > probe via sysfs cpu/probe interface, The function arch_cpu_probe will be called
> > __three__ times, but only one call is valid, so I add a check on `count` to
> > ignore the invalid calls.
> 
> hm, why does it get called three times?  Is that something which
> can/should be fixed in callers rather than in the callee?

It might be a bug in the caller, but just guess currently. I will investigate it.

-- 
Thanks & Regards,
Shaohui

