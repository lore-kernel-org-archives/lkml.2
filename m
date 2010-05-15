Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0EOMEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 08:04:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:27702 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab0EOMET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 08:04:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,236,1272870000"; 
   d="scan'208";a="277466178"
Date: Sat, 15 May 2010 19:59:50 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ak@linux.intel.co, fengguang.wu@intel.com,
       haicheng.li@linux.intel.com, shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 0/7] NUMA Hotplug emulator
Message-ID: <20100515115950.GA23083@shaohui>
Mail-Followup-To: Balbir Singh <balbir@linux.vnet.ibm.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ak@linux.intel.co,
	fengguang.wu@intel.com, haicheng.li@linux.intel.com,
	shaohui.zheng@linux.intel.com
References: <20100513113629.GA2169@shaohui>
 <20100514065744.GB3296@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514065744.GB3296@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 12:27:44PM +0530, Balbir Singh wrote:
> * Shaohui Zheng <shaohui.zheng@intel.com> [2010-05-13 19:36:30]:
> 
> > Hi, All
> > 	This patchset introduces NUMA hotplug emulator for x86. it refers too
> > many files and might introduce new bugs, so we send a RFC to comminity first
> > and expect comments and suggestions, thanks.
> > 
> > * WHAT IS HOTPLUG EMULATOR 
> > 
> > NUMA hotplug emulator is collectively named for the hotplug emulation
> > it is able to emulate NUMA Node Hotplug thru a pure software way. It
> > intends to help people easily debug and test node/cpu/memory hotplug
> > related stuff on a none-numa-hotplug-support machine, even an UMA machine.
> > 
> > The emulator provides mechanism to emulate the process of physcial cpu/mem
> > hotadd, it provides possibility to debug CPU and memory hotplug on the machines
> > without NUMA support for kenrel developers. It offers an interface for cpu
> > and memory hotplug test purpose.
> >
> 
> Sounds like an interesting project, could you please
> 
> Post your patches as threaded, ideally having 0/7 to 7/7 in a thread
> helps track the patches and comments.
> 
> -- 
> 	Three Cheers,
> 	Balbir

Sorry for the late response, I have no experience to post all the patches into one 
thread, I will consult local expert.

Thanks Balbir, because of your guys's feedbacks and review comments, the code quality
should be guaranteed. 

-- 
Thanks & Regards,
Shaohui

