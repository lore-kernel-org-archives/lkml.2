Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab0EMQ46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:56:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:52585 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757281Ab0EMQ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:56:56 -0400
Date: Thu, 13 May 2010 09:56:03 -0700
From: Greg KH <gregkh@suse.de>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 6/7] NUMA hotplug emulator
Message-ID: <20100513165603.GC25212@suse.de>
References: <20100513120016.GG2169@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513120016.GG2169@shaohui>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 08:00:16PM +0800, Shaohui Zheng wrote:
> hotplug emulator:extend memory probe interface to support NUMA
> 
> Extend memory probe interface to support an extra paramter nid,
> the reserved memory can be added into this node if node exists.
> 
> Add a memory section(128M) to node 3(boots with mem=1024m)
> 
> 	echo 0x40000000,3 > memory/probe
> 
> And more we make it friendly, it is possible to add memory to do
> 
> 	echo 3g > memory/probe
> 	echo 1024m,3 > memory/probe
> 
> It maintains backwards compatibility.

Again, please document this.

thanks,

greg k-h
