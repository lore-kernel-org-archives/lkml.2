Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0FHJUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:20:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:47916 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab0FHJUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:20:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,383,1272870000"; 
   d="scan'208";a="286302325"
Subject: Re: [PATCH -tip] perf, x86: Make a second write to performance
 counter if needed
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1275904085.1645.555.camel@laptop>
References: <20100602212304.GC5264@lenovo>
	 <1275904085.1645.555.camel@laptop>
Content-Type: text/plain
Date: Tue, 08 Jun 2010 17:18:39 +0800
Message-Id: <1275988719.17004.110.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 17:48 +0800, Peter Zijlstra wrote:
> On Thu, 2010-06-03 at 01:23 +0400, Cyrill Gorcunov wrote:
> > On Netburst PMU we need a second write to a performance counter
> > due to cpu erratum.
> > 
> > A simple flag test instead of alternative instructions was choosen
> > because wrmsrl is already a macro and if virtualization is turned
> > on will need an additional wrapper call which is more expencise.
> > 
> > nb: we should propably switch to jump-labels as only this facility
> > reach the mainline.
> 
> OK. Thanks Cyrill.


I tested this patch and it works well for pre-defined events.

Lin Ming

