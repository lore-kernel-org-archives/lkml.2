Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab0LJBf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:35:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:20960 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558Ab0LJBfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:35:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,322,1288594800"; 
   d="scan'208";a="685701612"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        Andi Kleen <ak@linux.intel.com>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Brown, Len" <len.brown@intel.com>, Yinghai Lu <Yinghai.Lu@sun.com>,
        "Li, Haicheng" <haicheng.li@intel.com>,
        Shaohui Zheng <shaohui.zheng@linux.intel.com>
Date: Fri, 10 Dec 2010 09:35:08 +0800
Subject: RE: [5/7,v8] NUMA Hotplug Emulator: Support cpu probe/release in
 x86_64
Thread-Topic: [5/7,v8] NUMA Hotplug Emulator: Support cpu probe/release in
 x86_64
Thread-Index: AcuXIALuGAJJUAcJT5GzbHvnQcqu1QATaMrQ
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF2A40FED661@shsmsx502.ccr.corp.intel.com>
References: <20101207010033.280301752@intel.com>
 <20101207010140.092555703@intel.com>
 <alpine.DEB.2.00.1012081334160.15658@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1012081334160.15658@chino.kir.corp.google.com>
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

Both Tejun's and my patches are under review process, the hotplug emulator patchset is much earlier than Tejun's patch. Currently, I did not know how to handle this situation.

It seems that I have 3 options:
1) continue to send this patchset based on current upstream kernel  
2) continue to send this patchset based on upstream kernel + Tejun's patch
3) Postpone the patchset until Tejun's patches are accepted.

Can someone provide some suggestions? Thanks so much.

Thanks & Regards,
Shaohui


-----Original Message-----
From: David Rientjes [mailto:rientjes@google.com] 
Sent: Thursday, December 09, 2010 5:37 AM
To: Zheng, Shaohui; Tejun Heo
Cc: Andrew Morton; linux-mm@kvack.org; linux-kernel@vger.kernel.org; haicheng.li@linux.intel.com; lethal@linux-sh.org; Andi Kleen; dave@linux.vnet.ibm.com; Greg Kroah-Hartman; Ingo Molnar; Brown, Len; Yinghai Lu; Li, Haicheng
Subject: Re: [5/7,v8] NUMA Hotplug Emulator: Support cpu probe/release in x86_64

On Tue, 7 Dec 2010, shaohui.zheng@intel.com wrote:

> From: Shaohui Zheng <shaohui.zheng@intel.com>
> 

This patch is undoubtedly going to conflict with Tejun's unification of 
the 32 and 64 bit NUMA boot paths, specifically the patch at 
http://marc.info/?l=linux-kernel&m=129087151912379.

Tejun, what's the status of that patchset posted on November 27?  Any 
comments about this change?
