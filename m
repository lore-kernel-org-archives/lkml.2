Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0F2SJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:09:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab0F2SJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:09:21 -0400
Subject: Re: [RFC][PATCH 09/11] perf: Default PMU ops
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100629180745.GA11967@nowhere>
References: <20100624142804.431553874@chello.nl>
	 <20100624143406.993794468@chello.nl> <20100629145806.GE5318@nowhere>
	 <1277823591.1868.43.camel@laptop> <20100629150305.GG5318@nowhere>
	 <1277829250.1868.46.camel@laptop>  <20100629180745.GA11967@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Jun 2010 20:09:10 +0200
Message-ID: <1277834950.1868.56.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 20:07 +0200, Frederic Weisbecker wrote:
> On Tue, Jun 29, 2010 at 06:34:10PM +0200, Peter Zijlstra wrote:
> > On Tue, 2010-06-29 at 17:03 +0200, Frederic Weisbecker wrote:
> > > > You mean, if (!pmu->start_txn && pmu->pmu_enable) { /* install defaults
> > > > */ } ?

> neglected pmu implementations shouldn't impact software pmus.

With the above and not providing ->pmu_enable you get that.


