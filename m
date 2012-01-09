Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2AIHQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:16:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:32241 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab2AIHQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:16:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="54578776"
Subject: Re: [patch v3]numa: add a sysctl to control interleave allocation
 granularity from each node to improve I/O performance
From: Shaohua Li <shaohua.li@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <1323912471.22361.431.camel@sli10-conroe>
References: <1323655125.22361.376.camel@sli10-conroe>
	 <20111213190632.GA5830@tassilo.jf.intel.com>
	 <alpine.DEB.2.00.1112131412320.27186@router.home>
	 <20111213203856.GA6312@tassilo.jf.intel.com>
	 <1323830027.22361.401.camel@sli10-conroe>
	 <20111214175302.GA2600@alboin.jf.intel.com>
	 <1323912471.22361.431.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 15:31:52 +0800
Message-ID: <1326094312.22361.557.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 09:27 +0800, Shaohua Li wrote:
> On Thu, 2011-12-15 at 01:53 +0800, Andi Kleen wrote:
> > > That's what I want to avoid letting each apps to explicitly do it, it's
> > > a lot of burden.
> > 
> > Usually apps that set NUMA policy can change it. Most don't anyways.
> > If it's just a script with numactl it's easily changed.
> Hmm, why should apps set different granularity? the granularity change
> is to speed up I/O, which should have the same value for all apps.
> 
> > > That's true only workload with heavy I/O wants this. but I don't expect
> > > it will harm other workloads.
> > 
> > How do you know?
> I can't imagine how it could harm. Some arches can use big pages, big
> granularity should already been tested for years.
ping ...


