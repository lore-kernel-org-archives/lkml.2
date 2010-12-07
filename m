Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0LHApE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:45:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:31077 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab0LHApC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:45:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,313,1288594800"; 
   d="scan'208";a="684929036"
Date: Wed, 8 Dec 2010 07:20:00 +0800
From: Shaohui Zheng <shaohui.zheng@linux.intel.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: shaohui.zheng@intel.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, rientjes@google.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/7,v8] NUMA Hotplug Emulator: documentation
Message-ID: <20101207232000.GA5353@shaohui>
References: <20101207010033.280301752@intel.com>
 <20101207010139.681125359@intel.com>
 <20101207182420.GA2038@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101207182420.GA2038@mgebm.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 11:24:20AM -0700, Eric B Munson wrote:
> Shaohui,
> 
> The documentation patch seems to be stale, it needs to be updated to match the
> new file names.
> 
Eric,
	the major change on the patchset is on the interface, for the v8 emulator,
we accept David's per-node debugfs add_memory interface, we already included
in the documentation patch. the change is very small, so it is not obvious.

This is the change on the documentation compare with v7:
+3) Memory hotplug emulation:
+
+The emulator reserves memory before OS boots, the reserved memory region is
+removed from e820 table. Each online node has an add_memory interface, and
+memory can be hot-added via the per-ndoe add_memory debugfs interface.
+
+The difficulty of Memory Release is well-known, we have no plan for it until
+now.
+
+ - reserve memory thru a kernel boot paramter
+ 	mem=1024m
+
+ - add a memory section to node 3
+    # echo 0x40000000 > mem_hotplug/node3/add_memory
+	OR
+    # echo 1024m > mem_hotplug/node3/add_memory
+

-- 
Thanks & Regards,
Shaohui

