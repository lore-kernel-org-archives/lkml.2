Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0GJNrm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 09:47:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59157 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab0GJNrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 09:47:40 -0400
Subject: Re: [RFC][PATCH 13/13] perf: Rework the PMU methods
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100710133647.GA5306@nowhere>
References: <20100709082117.631541128@chello.nl>
	 <20100709083248.337539831@chello.nl>  <20100710133647.GA5306@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 10 Jul 2010 15:47:22 +0200
Message-ID: <1278769642.1998.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-10 at 15:36 +0200, Frederic Weisbecker wrote:

> So, if I understood well, this is to avoid enabling an event from perf_pmu_enable()
> while the event was already stopped.

Right.

> Looks good but why this ARCH name then? This should be a kind of PERF_HES_ONCPU
> or so.

Because I failed to come up with a sensible name, ONCPU doesn't really
make sense either, its got nothing to do with CPUs.

_REALLY_STOPPED maybe, but then, that's a bad name too ;-)


