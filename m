Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1KQL7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:59:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:35894 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab1KQL7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:59:31 -0500
Date: Thu, 17 Nov 2011 12:59:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Luis Henriques <henrix@camandro.org>
cc: Yong Zhang <yong.zhang0@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -rt] memcg: use migrate_disable()/migrate_enable( ) in
 memcg_check_events()
In-Reply-To: <20111117114451.GC3762@hades>
Message-ID: <alpine.LFD.2.02.1111171258060.4902@ionos>
References: <alpine.LFD.2.02.1111150050590.4902@ionos> <20111115084059.GA23250@zhy> <20111116091653.GA8692@zhy> <1321452758.4181.18.camel@frodo> <alpine.LFD.2.02.1111161801270.4902@ionos> <20111117030332.GA14492@zhy> <alpine.LFD.2.02.1111171125020.4902@ionos>
 <20111117114451.GC3762@hades>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis,

On Thu, 17 Nov 2011, Luis Henriques wrote:

> On Thu, Nov 17, 2011 at 11:25:56AM +0100, Thomas Gleixner wrote:
> > Johannes came up with a different solution. Could you please give it a try?
> 
> Again, I've run a quick test and it looks like this solves the issue.

thanks for testing. That solution is way better than the local_lock
based one.

Thanks,

	tglx
