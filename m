Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab0ENIKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:10:44 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60964 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab0ENIKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:10:41 -0400
Date: Fri, 14 May 2010 13:37:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Shaohui Zheng <shaohui.zheng@intel.com>, akpm@linux-foundation.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, ak@linux.intel.co, fengguang.wu@intel.com,
       haicheng.li@linux.intel.com, shaohui.zheng@linux.intel.com
Subject: Re: [RFC,2/7] NUMA Hotplug emulator
Message-ID: <20100514080732.GC3296@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100513114544.GC2169@shaohui>
 <20100514111615.c7ca63a5.kamezawa.hiroyu@jp.fujitsu.com>
 <20100514054226.GB12002@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100514054226.GB12002@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Mundt <lethal@linux-sh.org> [2010-05-14 14:42:26]:

> On Fri, May 14, 2010 at 11:16:15AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 13 May 2010 19:45:44 +0800
> > Shaohui Zheng <shaohui.zheng@intel.com> wrote:
> > 
> > > x86: infrastructure of NUMA hotplug emulation
> > > 
> > 
> > Hmm. do we have to create this for x86 only ?
> > Can't we live with lmb ? as
> > 
> > 	lmb_hide_node() or some.
> > 
> > IIUC, x86-version lmb is now under development.
> > 
> Indeed. There is very little x86-specific about this patch series at all
> except for the e820 bits and tying in the CPU topology. Most of what this
> series is doing wrapping around e820 could be done on top of LMB, which
> would also make it possible to use on non-x86 architectures.
>

Yes, that would be very nice addition 

-- 
	Three Cheers,
	Balbir
