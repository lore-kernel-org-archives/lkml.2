Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab0KRDwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 22:52:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:17927 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab0KRDwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 22:52:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,215,1288594800"; 
   d="scan'208";a="350213641"
Date: Thu, 18 Nov 2010 10:31:14 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [8/8,v3] NUMA Hotplug Emulator: documentation
Message-ID: <20101118023114.GB1980@shaohui>
References: <20101117020759.016741414@intel.com>
 <20101117021000.985643862@intel.com>
 <20101117150659.0e0473c7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117150659.0e0473c7.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:06:59PM -0800, Randy Dunlap wrote:
> On Wed, 17 Nov 2010 10:08:07 +0800 shaohui.zheng@intel.com wrote:
> 
> > From: Shaohui Zheng <shaohui.zheng@intel.com>
> > 
> > add a text file Documentation/x86/x86_64/numa_hotplug_emulator.txt
> > to explain the usage for the hotplug emulator.
> > 
> > Signed-off-by: Haicheng Li <haicheng.li@intel.com>
> > Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
> > ---
> > Index: linux-hpe4/Documentation/x86/x86_64/numa_hotplug_emulator.txt
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-hpe4/Documentation/x86/x86_64/numa_hotplug_emulator.txt	2010-11-17 09:01:10.342836513 +0800
> > @@ -0,0 +1,92 @@
> > +NUMA Hotplug Emulator for x86
> 
> (I'm only looking at the documentation file.)
> 
> Is this only for x86_64?  if so, please change the line above (for x86).
> If not, then don't put this file into the /x86_64/ sub-directory.

There are only a few x86_64 specific codes on the patch series, so it should
work for both x86_64 and i386. Currently cpu/memory hotplug works stable against
x86_64 kernel, it still has many issues for i386, so we can not do the testing
for emualtor on i386 kernel, I'd prefer to keep the document for x86_64 only.

> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
I will check the documentation once again, thanks for the careful review from Randy.

-- 
Thanks & Regards,
Shaohui

