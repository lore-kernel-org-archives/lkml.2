Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab0FPR7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:59:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:47041 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab0FPR7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:59:09 -0400
Subject: Re: [RFC][PATCH 6/8] perf: Per PMU disable
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100616174804.GT21799@erda.amd.com>
References: <20100616160027.590430763@chello.nl>
	 <20100616160238.529009255@chello.nl>  <20100616174804.GT21799@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 19:58:57 +0200
Message-ID: <1276711137.1745.610.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 19:48 +0200, Robert Richter wrote:
> On 16.06.10 12:00:33, Peter Zijlstra wrote:
> > Changes perf_disable() into perf_disable_pmu().
> 
> I would rather use perf_pmu_disable() as this uses the perf_pmu_XXX
> namespace.

Sure..

sed -i -e 's/perf_disable_pmu/perf_pmu_disable/g' -e 's/perf_enable_pmu/perf_pmu_enable/g' `quilt series`


