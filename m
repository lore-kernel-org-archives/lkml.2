Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0IRPTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 11:19:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46060 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0IRPTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 11:19:08 -0400
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1284761553.2676.21.camel@sbsiddha-MOBL3.sc.intel.com>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
	 <1284116817.402.33.camel@laptop>
	 <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
	 <1284196838.2251.12.camel@laptop>
	 <AANLkTi=Vrd0g-64oRYLo6fTj1SYYa++VG57vGn608tkA@mail.gmail.com>
	 <1284400941.2684.19.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1284451427.2275.462.camel@laptop>
	 <20100914111954.GB2201@osiris.boeblingen.de.ibm.com>
	 <1284761553.2676.21.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 18 Sep 2010 17:18:47 +0200
Message-ID: <1284823127.2275.604.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 15:12 -0700, Suresh Siddha wrote:
> On Tue, 2010-09-14 at 04:19 -0700, Heiko Carstens wrote:
> > > 
> > > So what patches are we going to merge?
> > > 
> > > I share Heiko's opinion on that its somewhat surprising to have
> > > __smp_call_function_single() differ in this detail from
> > > smp_call_function_single() and think that merging his patch would be
> > > good in that respect. But Andrew seemed to have reservations.
> > > 
> > > We can also merge either my or Suresh's patch (which I think makes
> > > sense, but is kinda subtle) to avoid the needless self kick.
> 
> Peter, Can you please merge my patch instead of yours, as mine is more
> appropriate here. And also I would like Heiko's patch also to be merged
> as that brings smp_call_function_single() and
> __smp_call_function_single() to similar behavior.

Sure can do. Thanks!
