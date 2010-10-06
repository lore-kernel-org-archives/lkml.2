Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab0JFNmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:42:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:43230 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab0JFNmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:42:31 -0400
Subject: Re: [PATCH 1/7] perf: Add helper function to return number of
 counters
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Matt Fleming <matt@console-pimps.org>, Will Deacon <will.deacon@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <20101006121410.GK13563@erda.amd.com>
References: <cover.1286222593.git.matt@console-pimps.org>
	 <c4eb88b09da564fe093cc6571ed747971425e69a.1286222593.git.matt@console-pimps.org>
	 <20101006121410.GK13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Oct 2010 15:41:32 +0200
Message-ID: <1286372492.2144.181.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 14:14 +0200, Robert Richter wrote:
> > +int perf_num_counters(void)
> > +{
> > +     return armpmu_get_max_events();
> > +}
> > +EXPORT_SYMBOL_GPL(perf_num_counters);
> 
> Peter,
> 
> can you please ack this interface? 

It does seem like the best way forward for this, so

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


