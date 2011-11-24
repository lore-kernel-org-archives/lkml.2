Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1KXKYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:24:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:39802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1KXKYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:24:46 -0500
Message-ID: <1322130279.2921.7.camel@twins>
Subject: Re: [patch 1/6] sched, nohz: introduce nohz_flags in the struct rq
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com
Date: Thu, 24 Nov 2011 11:24:39 +0100
In-Reply-To: <20111118230553.882444396@sbsiddha-desk.sc.intel.com>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230553.882444396@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 15:03 -0800, Suresh Siddha wrote:
> plain text document attachment (introduce_rq_nohz_flags.patch)
> Introduce nohz_flags in the struct rq, which will track two flags for now.
> 
> NOHZ_TICK_STOPPED will convey the stop tick status that gets set when
> the tick is stopped and cleared during the first busy tick after the tick
> is restarted.
> 
> NOHZ_BALANCE_KICK will track the need for nohz idle load balance
> on this rq.

The changelog is missing the crucial part: Why are we doing this? :-)
