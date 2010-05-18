Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0ERIFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 04:05:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:63392 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab0ERIFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 04:05:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,254,1272870000"; 
   d="scan'208";a="278348772"
Date: Tue, 18 May 2010 15:56:48 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@suse.de>, akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
Message-ID: <20100518075648.GA26105@shaohui>
Mail-Followup-To: Dave Hansen <dave@linux.vnet.ibm.com>,
	Greg KH <gregkh@suse.de>, akpm@linux-foundation.org,
	linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
	shaohui.zheng@linux.intel.com
References: <20100513120016.GG2169@shaohui>
 <20100513165603.GC25212@suse.de>
 <1273773737.13285.7771.camel@nimitz>
 <20100513181539.GA26597@suse.de>
 <1273776578.13285.7820.camel@nimitz>
 <20100518054121.GA25298@shaohui>
 <1274167625.17463.17.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274167625.17463.17.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 12:27:05AM -0700, Dave Hansen wrote:
> On Tue, 2010-05-18 at 13:41 +0800, Shaohui Zheng wrote:
> > On Thu, May 13, 2010 at 11:49:38AM -0700, Dave Hansen wrote:
> > the configfs was introduced in 2005, you can refer to http://lwn.net/Articles/148973/.
> > 
> > I enabled the configfs, and I see that the configfs is not so popular as we expected,
> > I mount configfs to /sys/kernel/config, I get an empty directory. It means that nobody is 
> > using this file system, it is an interesting thing, is it means that configfs is deprecated?
> > If so, it might not be nessarry to develop a configfs interface for hotplug.
> 
> Uh, deprecated?  What would make you think that?  It does look like the
> users are a we bit obscure, but that's a bit far from deprecated.
> 
> > Dave & Greg,
> > 	Can you provide an exmample to use configfs as interface in Linux kernel, I want to get
> > a live demo, thanks.
> 
> Heh.  There are some great tools out there called cscope and grep.  I
> have them on my system and I bet you can get them on yours too.
> 
> That said, you're right.  There don't seem to be a ton of users of it
> these days.  But, the LWN article you referenced also pointed to at
> least one user.  So, please try and put a wee bit of effort into it.

I am trying to put a few efforts on it, and we hope to support both sysfs and configfs.

because of the history reason, sysfs is more popular. I bet that only vew few users know
 configfs, so sysfs is still the prefered way.

> 
> Maybe configfs isn't the way to go.  I just think extending the 'probe'
> file is a bad idea, especially in the way your patch did it.  I'm open
> to other alternatives.  Since this is only for testing, perhaps debugfs
> applies better.  What other alternatives have you explored?  How about a
> Systemtap set to do it? :)
> 
> -- Dave

Did not try other alternatives until now. Thanks for Dave's suggestions, Systemtap and debugfs
 seems to be good methods, too.


-- 
Thanks & Regards,
Shaohui

