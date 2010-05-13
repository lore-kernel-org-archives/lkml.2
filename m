Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab0EMSt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:49:57 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56189 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab0EMStz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:49:55 -0400
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
In-Reply-To: <20100513181539.GA26597@suse.de>
References: <20100513120016.GG2169@shaohui> <20100513165603.GC25212@suse.de>
	 <1273773737.13285.7771.camel@nimitz>  <20100513181539.GA26597@suse.de>
Content-Type: text/plain
Date: Thu, 13 May 2010 11:49:38 -0700
Message-Id: <1273776578.13285.7820.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 11:15 -0700, Greg KH wrote:
> >       echo "physical_address=0x40000000 numa_node=3" > memory/probe
> > 
> > I'd *GREATLY* prefer that over this new syntax.  The existing mechanism
> > is obtuse enough, and the ',3' makes it more so.
> > 
> > We should have the code around to parse arguments like that, too, since
> > we use it for the boot command-line.
> 
> If you are going to be doing something like this, please use configfs,
> that is what it is designed for, not sysfs.

That's probably a really good point, especially since configfs didn't
even exist when we made this 'probe' file thingy.  It never was a great
fit for sysfs anyway.

-- Dave

