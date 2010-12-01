Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab0LBBIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:08:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:5863 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab0LBBIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:08:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="863356846"
Date: Thu, 2 Dec 2010 07:45:14 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [8/8, v6] NUMA Hotplug Emulator: implement debugfs interface
 for memory probe
Message-ID: <20101201234514.GA13509@shaohui>
References: <20101130071324.908098411@intel.com>
 <20101130071437.461969179@intel.com>
 <alpine.DEB.2.00.1012011656590.1896@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012011656590.1896@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 04:57:35PM -0800, David Rientjes wrote:
> On Tue, 30 Nov 2010, shaohui.zheng@intel.com wrote:
> 
> > From: Shaohui Zheng <shaohui.zheng@intel.com>
> > 
> > Implement a debugfs inteface /sys/kernel/debug/mem_hotplug/probe for meomory hotplug
> > emulation.  it accepts the same parameters like
> > /sys/devices/system/memory/probe.
> > 
> 
> NACK, we don't need two interfaces to do the same thing.  

You may not know the background, the sysfs memory/probe interface is a general
interface.  Even through we have a debugfs interface, we should still keep it.

For test purpose, the sysfs is enough, according to the comments from Greg & Dave,
we create the debugfs interface.

-- 
Thanks & Regards,
Shaohui

