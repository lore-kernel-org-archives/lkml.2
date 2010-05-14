Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab0ENHAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:00:32 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:35194 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab0ENHAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:00:30 -0400
Date: Fri, 14 May 2010 12:27:44 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ak@linux.intel.co, fengguang.wu@intel.com,
       haicheng.li@linux.intel.com, shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 0/7] NUMA Hotplug emulator
Message-ID: <20100514065744.GB3296@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100513113629.GA2169@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100513113629.GA2169@shaohui>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shaohui Zheng <shaohui.zheng@intel.com> [2010-05-13 19:36:30]:

> Hi, All
> 	This patchset introduces NUMA hotplug emulator for x86. it refers too
> many files and might introduce new bugs, so we send a RFC to comminity first
> and expect comments and suggestions, thanks.
> 
> * WHAT IS HOTPLUG EMULATOR 
> 
> NUMA hotplug emulator is collectively named for the hotplug emulation
> it is able to emulate NUMA Node Hotplug thru a pure software way. It
> intends to help people easily debug and test node/cpu/memory hotplug
> related stuff on a none-numa-hotplug-support machine, even an UMA machine.
> 
> The emulator provides mechanism to emulate the process of physcial cpu/mem
> hotadd, it provides possibility to debug CPU and memory hotplug on the machines
> without NUMA support for kenrel developers. It offers an interface for cpu
> and memory hotplug test purpose.
>

Sounds like an interesting project, could you please

Post your patches as threaded, ideally having 0/7 to 7/7 in a thread
helps track the patches and comments.

-- 
	Three Cheers,
	Balbir
