Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab0GIQJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:09:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:37946 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab0GIQJw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:09:52 -0400
Subject: Re: [RFC][PATCH 00/13] perf pmu interface changes -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1278688302.9864.9.camel@e102144-lin.cambridge.arm.com>
References: <20100709082117.631541128@chello.nl>
	 <1278688302.9864.9.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 18:09:32 +0200
Message-ID: <1278691772.1900.248.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 16:11 +0100, Will Deacon wrote:
> 
> The function names aren't especially helpful here either:
> armpmu_{start,stop} call armpmu->{enable,disable} and
> armpmu_{enable,disable} call armpmu->{start,stop}! 

Yes, that is rather unfortunate. Maybe we can clean that up once the
dust settles a bit.
