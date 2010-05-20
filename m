Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0ETIXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:23:14 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35479 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0ETIXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:23:11 -0400
Date: Thu, 20 May 2010 10:23:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, suresh.b.siddha@intel.com, mingo@elte.hu,
       tglx@linutronix.de, arjan@linux.jf.intel.com, venki@google.com,
       svaidy@linux.vnet.ibm.com, ego@in.ibm.com, linux-kernel@vger.kernel.org,
       linux@dominikbrodowski.net, ncunningham@crca.org.au
Subject: Re: [patch 3/7] softirq: avoid softirq_work_list for SCHED_SOFTIRQ
	when sent remotely
Message-ID: <20100520082309.GH25951@kernel.dk>
References: <20100517182726.089700767@sbs-t61.sc.intel.com> <20100517184027.777058425@sbs-t61.sc.intel.com> <1274343159.5605.13325.camel@twins> <20100520.011432.209562565.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520.011432.209562565.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20 2010, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Thu, 20 May 2010 10:12:39 +0200
> 
> > Most odd all that, Dave, Jens, what happened to all that remote_softirq
> > stuff?
> 
> Nobody ended up using this remote softirq infrastructure, it can be
> completely deleted.

What parts of it? There has been reworks of parts of the code since I
added it, the block layer only uses __smp_call_function_single() to
trigger remote softirqs.

-- 
Jens Axboe

