Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab1BWFa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:30:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:58273 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914Ab1BWFa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:30:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,210,1297065600"; 
   d="scan'208";a="890327783"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Haicheng Li <haicheng.li@linux.intel.com>,
        David Rientjes <rientjes@google.com>
CC: "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        Andi Kleen <ak@linux.intel.com>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "You, Yongkang" <yongkang.you@intel.com>
Date: Wed, 23 Feb 2011 13:29:24 +0800
Subject: RE: [0/7, v9] NUMA Hotplug Emulator (v9)
Thread-Topic: [0/7, v9] NUMA Hotplug Emulator (v9)
Thread-Index: AcvTCebv/xW0mlHQTD+t/MdK/atwoAAEIF/A
Message-ID: <749B9D3DBF0F054390025D9EAFF47F22333D016D@shsmsx501.ccr.corp.intel.com>
References: <20101210073119.156388875@intel.com>
 <alpine.DEB.2.00.1102221429030.31758@chino.kir.corp.google.com>
 <4D647F1D.2000307@linux.intel.com>
In-Reply-To: <4D647F1D.2000307@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am rebasing the patch now. I will send out it when i finish.

best regards
yang


> -----Original Message-----
> From: Haicheng Li [mailto:haicheng.li@linux.intel.com]
> Sent: Wednesday, February 23, 2011 11:30 AM
> To: David Rientjes
> Cc: Zheng, Shaohui; Andrew Morton; linux-mm@kvack.org;
> linux-kernel@vger.kernel.org; lethal@linux-sh.org; Andi Kleen;
> dave@linux.vnet.ibm.com; Greg Kroah-Hartman; Zhang, Yang Z; You, Yongkang
> Subject: Re: [0/7, v9] NUMA Hotplug Emulator (v9)
> 
> Shaohui is out of position recently. Include Yang Zhang and Yongkang You in
> this loop, who are Shaohui's backup.
> 
> David Rientjes wrote:
> > On Fri, 10 Dec 2010, shaohui.zheng@intel.com wrote:
> >
> >> v9:
> >>
> >> Solve the bug reported by Eric B Munson, check the return value of
> cpu_down when do
> >>  CPU release.
> >>
> >> Solve the conflicts with Tejun Heo' Unificaton NUMA code, re-work patch 5
> based on his
> >> patch.
> >>
> >> Some small changes on debugfs per-node add_memory interface.
> >>
> >
> > Hi Shaohui,
> >
> > Tejun's NUMA unification work has been merged into x86/mm, so I think it
> > would possible to rebase your hotplug emulator patchset on top of it
> > without too many conflicts now.
> >
> > It should probably be based on x86/mm from
> > http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
