Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab0EMQ7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:59:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344Ab0EMQ7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:59:35 -0400
Date: Thu, 13 May 2010 09:55:11 -0700
From: Greg KH <gregkh@suse.de>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, ak@linux.intel.com,
       fengguang.wu@intel.com, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
Subject: Re: [RFC, 3/7] NUMA hotplug emulator
Message-ID: <20100513165511.GB25212@suse.de>
References: <20100513114835.GD2169@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513114835.GD2169@shaohui>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 07:48:35PM +0800, Shaohui Zheng wrote:
> Userland interface to hotplug-add fake offlined nodes.

Why include 2 copies of the patch in one email?

> Add a sysfs entry "probe" under /sys/devices/system/node/:
> 
>  - to show all fake offlined nodes:
>     $ cat /sys/devices/system/node/probe
> 
>  - to hotadd a fake offlined node, e.g. nodeid is N:
>     $ echo N > /sys/devices/system/node/probe

As you are trying to add a new sysfs file, please create the matching
Documentation/ABI/ file as well.

Also note that sysfs files are "one value per file", which I don't think
this file follows, right?

thanks,

greg k-h
