Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0FWUqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:46:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:57313 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab0FWUqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:46:21 -0400
Subject: Re: [RFC][PATCH 8/8] perf: Rework the PMU methods
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100622162652.GB5458@nowhere>
References: <20100616160027.590430763@chello.nl>
	 <20100616160238.721536975@chello.nl> <20100618042143.GE5345@nowhere>
	 <1276845338.27822.1450.camel@twins>  <20100622162652.GB5458@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 22 Jun 2010 19:10:22 +0200
Message-ID: <1277226622.27822.7873.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 18:26 +0200, Frederic Weisbecker wrote:
> > > It would be nice to have a PERF_EF_STOP as well in ->del, so that
> > > each pmu don't need to maintain an internal state.
> > 
> > You have to track it since we can stop the thing outselves without the
> > caller knowing.
> 
> 
> From the pmu internals yeah, that's what the x86 pmu does. But otherwise, other
> pmu don't do such things. 

Everybody who does throttling will have to.
