Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415Ab0EMTHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:07:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:55679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360Ab0EMTHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:07:05 -0400
Date: Thu, 13 May 2010 11:58:44 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
Message-ID: <20100513185844.GA5959@suse.de>
References: <20100513120016.GG2169@shaohui>
 <20100513165603.GC25212@suse.de>
 <1273773737.13285.7771.camel@nimitz>
 <20100513181539.GA26597@suse.de>
 <1273776578.13285.7820.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273776578.13285.7820.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 11:49:38AM -0700, Dave Hansen wrote:
> On Thu, 2010-05-13 at 11:15 -0700, Greg KH wrote:
> > >       echo "physical_address=0x40000000 numa_node=3" > memory/probe
> > > 
> > > I'd *GREATLY* prefer that over this new syntax.  The existing mechanism
> > > is obtuse enough, and the ',3' makes it more so.
> > > 
> > > We should have the code around to parse arguments like that, too, since
> > > we use it for the boot command-line.
> > 
> > If you are going to be doing something like this, please use configfs,
> > that is what it is designed for, not sysfs.
> 
> That's probably a really good point, especially since configfs didn't
> even exist when we made this 'probe' file thingy.  It never was a great
> fit for sysfs anyway.

Really?  configfs was added in 2.6.16, when was this probe file added?

thanks,

greg k-h
