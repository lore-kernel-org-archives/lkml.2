Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0GIIgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:36:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:49071 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab0GIIgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:36:12 -0400
Subject: Re: [RFC][PATCH 08/11] perf: Per PMU disable
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100709073127.GQ7771@brick.ozlabs.ibm.com>
References: <20100624142804.431553874@chello.nl>
	 <20100624143406.936055007@chello.nl>
	 <20100709073127.GQ7771@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 10:36:04 +0200
Message-ID: <1278664564.1900.192.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 17:31 +1000, Paul Mackerras wrote:
> On Thu, Jun 24, 2010 at 04:28:12PM +0200, Peter Zijlstra wrote:
> 
> > Changes perf_disable() into perf_pmu_disable().
> 
> Needs this rolled in to compile on powerpc.

Done (a week or so ago, should have reposted, will do in a moment).
