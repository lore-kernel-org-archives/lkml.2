Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0LBBMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 20:12:21 -0500
Received: from mga14.intel.com ([143.182.124.37]:35949 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab0LBBMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 20:12:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="355834356"
Date: Thu, 2 Dec 2010 07:48:39 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8, v6] NUMA Hotplug Emulator: Add numa=possible option
Message-ID: <20101201234839.GB13509@shaohui>
References: <20101130071324.908098411@intel.com>
 <20101130071436.836186525@intel.com>
 <alpine.DEB.2.00.1012011705280.6088@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012011705280.6088@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 05:06:02PM -0800, David Rientjes wrote:
> On Tue, 30 Nov 2010, shaohui.zheng@intel.com wrote:
> 
> > From:  David Rientjes <rientjes@google.com>
> > 
> > Adds a numa=possible=<N> command line option to set an additional N nodes
> > as being possible for memory hotplug.  This set of possible nodes
> > controls nr_node_ids and the sizes of several dynamically allocated node
> > arrays.
> > 
> > This allows memory hotplug to create new nodes for newly added memory
> > rather than binding it to existing nodes.
> > 
> > The first use-case for this will be node hotplug emulation which will use
> > these possible nodes to create new nodes to test the memory hotplug
> > callbacks and surrounding memory hotplug code.
> > 
> > CC: Shaohui Zheng <shaohui.zheng@intel.com>
> > CC: Haicheng Li <haicheng.li@intel.com>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> You're going to need to add your Signed-off-by line immediately after mine 
> if you're pushing these to a maintainer, you're along the submission 
> chain.

I did not add my name as Signed-off-by since you are the patch author, I will
add it, thanks David.

-- 
Thanks & Regards,
Shaohui

