Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab0K3Cyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 21:54:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:62607 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab0K3Cyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 21:54:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,278,1288594800"; 
   d="scan'208";a="682204459"
Date: Tue, 30 Nov 2010 09:31:21 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        rientjes@google.com, dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [8/8, v5] NUMA Hotplug Emulator: documentation
Message-ID: <20101130013121.GC3021@shaohui>
References: <20101129091750.950277284@intel.com>
 <20101129091936.322099405@intel.com>
 <14037.1291054756@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14037.1291054756@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 01:19:16PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 29 Nov 2010 17:17:58 +0800, shaohui.zheng@intel.com said:
> > From: Shaohui Zheng <shaohui.zheng@intel.com>
> > 
> > add a text file Documentation/x86/x86_64/numa_hotplug_emulator.txt
> > to explain the usage for the hotplug emulator.
> 
> Can you renumber this to 1/8 if you resubmit it?  It helps code review if you
> already know what it's *intended* to do beforehand.  It also helps drinking
> from the lkml firehose if you can read 0/N and 1/N and know if it's something
> you want to review, otherwise you read 0/N, have to go find N/N, read that,
> then go back and delete 1/N through N-1/N.
> 
> (Sometimes, the 0/N cover isn't enough - reading the documentation actually
> fills in enough blanks to make you go "Wow, this *is* applicable to something
> I'm working on...")

When I send the previous version, I always add the full documentation in 0/N 
patches. The feedbacks, suggestions, and modifications are all included in 0/N 
patch. it makes it as a very long text, so I decide to remove the full documentation
from 0/N since we already send these docs in early version, it get the 0/N patch
 much smaller.

I will still keep the full documentation in 0/N, and renumber 8/8 to 1/8. Thanks
 for the remind.


-- 
Thanks & Regards,
Shaohui

