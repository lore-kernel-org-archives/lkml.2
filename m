Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab2AJByw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 20:54:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:49412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab2AJByv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 20:54:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105303495"
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        arjan@linux.intel.com, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
In-Reply-To: <CAKfTPtDM-L-AcHr_o44vmR9VYRvQqOyXuwEgnZ61d4pbDOPFUg@mail.gmail.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	 <1326103578.2442.50.camel@twins>
	 <20120110001445.GA20542@linux-youquan.bj.intel.com>
	 <1326107563.2442.65.camel@twins>
	 <CAKfTPtDM-L-AcHr_o44vmR9VYRvQqOyXuwEgnZ61d4pbDOPFUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Mon, 09 Jan 2012 17:54:21 -0800
Message-ID: <1326160461.2366.19.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 15:29 +0100, Vincent Guittot wrote: 
> Hi Peter,
> 
> I'm also using sched_mc level for doing powersaving load balance on
> ARM platform and we have real benefits.

hi Vincent, Can you elaborate on your platform topology where you see
the benefits?

on x86, 'sched_mc' was designed for the case of consolidating load into
one socket before using another idle socket.

Just wondering if this is your use case too or if you are consolidating
at a different topological level.

thanks,
suresh 

