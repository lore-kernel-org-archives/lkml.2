Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab0ERH1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 03:27:15 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56218 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab0ERH1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 03:27:11 -0400
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: Greg KH <gregkh@suse.de>, akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
In-Reply-To: <20100518054121.GA25298@shaohui>
References: <20100513120016.GG2169@shaohui> <20100513165603.GC25212@suse.de>
	 <1273773737.13285.7771.camel@nimitz> <20100513181539.GA26597@suse.de>
	 <1273776578.13285.7820.camel@nimitz>  <20100518054121.GA25298@shaohui>
Content-Type: text/plain
Date: Tue, 18 May 2010 00:27:05 -0700
Message-Id: <1274167625.17463.17.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 13:41 +0800, Shaohui Zheng wrote:
> On Thu, May 13, 2010 at 11:49:38AM -0700, Dave Hansen wrote:
> the configfs was introduced in 2005, you can refer to http://lwn.net/Articles/148973/.
> 
> I enabled the configfs, and I see that the configfs is not so popular as we expected,
> I mount configfs to /sys/kernel/config, I get an empty directory. It means that nobody is 
> using this file system, it is an interesting thing, is it means that configfs is deprecated?
> If so, it might not be nessarry to develop a configfs interface for hotplug.

Uh, deprecated?  What would make you think that?  It does look like the
users are a we bit obscure, but that's a bit far from deprecated.

> Dave & Greg,
> 	Can you provide an exmample to use configfs as interface in Linux kernel, I want to get
> a live demo, thanks.

Heh.  There are some great tools out there called cscope and grep.  I
have them on my system and I bet you can get them on yours too.

That said, you're right.  There don't seem to be a ton of users of it
these days.  But, the LWN article you referenced also pointed to at
least one user.  So, please try and put a wee bit of effort into it.

Maybe configfs isn't the way to go.  I just think extending the 'probe'
file is a bad idea, especially in the way your patch did it.  I'm open
to other alternatives.  Since this is only for testing, perhaps debugfs
applies better.  What other alternatives have you explored?  How about a
Systemtap set to do it? :)

-- Dave

