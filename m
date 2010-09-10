Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0IJEj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 00:39:58 -0400
Received: from ozlabs.org ([203.10.76.45]:43462 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab0IJEj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 00:39:57 -0400
Date: Fri, 10 Sep 2010 14:39:52 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/19] perf pmu interface changes -v4
Message-ID: <20100910043952.GA9100@drongo>
References: <20100907164633.879932949@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907164633.879932949@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 06:46:33PM +0200, Peter Zijlstra wrote:

> These patches prepare the perf code for multiple PMUs.
> 
> About the first half of these patches deals with removing all the weak
> functions, the second half provides per pmu contexts.
> 
> New to the first half is Alpha, which got merged into mainline recently.
> 
> The second half is completely new and lightly tested, one known breakage is
> that it currently doesn't allow to mix software and hardware events into a
> single group (should be fixed soon).

I see Ingo committed this series into the tip perf/core branch.  Did
this problem get fixed before that, or does it still need to be fixed?

Paul.
