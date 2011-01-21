Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1AURfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:35:46 -0500
Received: from www.tglx.de ([62.245.132.106]:33398 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab1AURfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:35:45 -0500
Date: Fri, 21 Jan 2011 18:34:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH V4] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and remove unrelated boosting
In-Reply-To: <4D3012D5.4060709@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1101211833120.2971@localhost6.localdomain6>
References: <4D07330A.7020600@cn.fujitsu.com>  <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>  <4D083900.1050801@cn.fujitsu.com>  <1292386606.5015.1862.camel@gandalf.stny.rr.com>  <4D130D23.1040309@cn.fujitsu.com>  <1294851790.26623.372.camel@gandalf.stny.rr.com>
  <1294851864.26623.373.camel@gandalf.stny.rr.com> <1294851934.26623.374.camel@gandalf.stny.rr.com> <4D3012D5.4060709@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011, Lai Jiangshan wrote:
> On 01/13/2011 01:05 AM, Steven Rostedt wrote:

Does not apply to mainline. Can you please redo ?

Thanks,

	tglx
