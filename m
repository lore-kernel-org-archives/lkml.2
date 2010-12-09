Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab0LIB6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:58:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:34286 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab0LIB6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:58:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,318,1288594800"; 
   d="scan'208";a="359119802"
Date: Thu, 9 Dec 2010 08:33:29 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Shaohui Zheng <shaohui.zheng@linux.intel.com>,
        Eric B Munson <emunson@mgebm.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        dave@linux.vnet.ibm.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/7,v8] NUMA Hotplug Emulator: documentation
Message-ID: <20101209003328.GC5798@shaohui>
References: <20101207010033.280301752@intel.com>
 <20101207010139.681125359@intel.com>
 <20101207182420.GA2038@mgebm.net>
 <20101207232000.GA5353@shaohui>
 <alpine.DEB.2.00.1012081316530.15658@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012081316530.15658@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 01:18:02PM -0800, David Rientjes wrote:
> On Wed, 8 Dec 2010, Shaohui Zheng wrote:
> 
> > Eric,
> > 	the major change on the patchset is on the interface, for the v8 emulator,
> > we accept David's per-node debugfs add_memory interface, we already included
> > in the documentation patch. the change is very small, so it is not obvious.
> > 
> 
> It's still stale as Eric mentioned: for instance, the reference to 
> /sys/kernel/debug/node/add_node which is now under mem_hotplug.  There may 
> be other examples as well.

I forget to udpate this part, my carelessness, thanks Eric and David.

-- 
Thanks & Regards,
Shaohui

