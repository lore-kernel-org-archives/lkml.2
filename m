Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab1JRDS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 23:18:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:51825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab1JRDS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 23:18:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,362,1315206000"; 
   d="scan'208";a="79095084"
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
From: "Alex,Shi" <alex.shi@intel.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <alpine.DEB.2.00.1110120910540.26610@router.home>
References: <1318237851.27949.190.camel@debian>
	 <alpine.DEB.2.00.1110101026080.16264@router.home>
	 <1318324774.27949.693.camel@debian>
	 <alpine.DEB.2.00.1110110910480.3388@router.home>
	 <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>
	 <alpine.DEB.2.00.1110120910540.26610@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 11:21:31 +0800
Message-ID: <1318908091.23426.52.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 22:11 +0800, Christoph Lameter wrote:
> On Wed, 12 Oct 2011, Alex,Shi wrote:
> 
> > I thought again of this_cpu_xxx function, yes, some of them are better
> > to be replaced by __this_cpu__xxx if preemption is safe on the scenario.
> > But this change is better to be done in another patch. I did not
> > finished all changed function check today.  May try again in next week.
> > What's you pinion of this?
> 
> I think its good to have it all in a single patch.
> 

I thought over your requirements, but it is difficult for me to know
lots of fields in kernel, like for xen/kvm/network etc. So, to avoid
introduce bugs here, could we do this blind changes, and then change
each of fields and get owner's ack separately. 

Anyway if you still want to keep all changes in one patch, the patch may
needs long time to wait for each of reviews/acks one by one. 




