Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab1LNRxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:53:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:55404 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab1LNRxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:53:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85714641"
Date: Wed, 14 Dec 2011 09:53:02 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Christoph Lameter <cl@linux.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch v3]numa: add a sysctl to control interleave allocation
 granularity from each node to improve I/O performance
Message-ID: <20111214175302.GA2600@alboin.jf.intel.com>
References: <1323655125.22361.376.camel@sli10-conroe>
 <20111213190632.GA5830@tassilo.jf.intel.com>
 <alpine.DEB.2.00.1112131412320.27186@router.home>
 <20111213203856.GA6312@tassilo.jf.intel.com>
 <1323830027.22361.401.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323830027.22361.401.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's what I want to avoid letting each apps to explicitly do it, it's
> a lot of burden.

Usually apps that set NUMA policy can change it. Most don't anyways.
If it's just a script with numactl it's easily changed.

> That's true only workload with heavy I/O wants this. but I don't expect
> it will harm other workloads.

How do you know? 

> 
> >> Also I don't like having more per task state. Could you compute this
> >> from the address instead even for the process policy case?
> >
> >That sounds good.
> the process policy case doesn't give an address for allocation.

That's true.

-Andi
