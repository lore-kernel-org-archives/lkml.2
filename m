Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0ETJRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:17:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56113
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653Ab0ETJRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:17:54 -0400
Date: Thu, 20 May 2010 02:18:02 -0700 (PDT)
Message-Id: <20100520.021802.38283651.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: peterz@infradead.org, suresh.b.siddha@intel.com, mingo@elte.hu,
       tglx@linutronix.de, arjan@linux.jf.intel.com, venki@google.com,
       svaidy@linux.vnet.ibm.com, ego@in.ibm.com, linux-kernel@vger.kernel.org,
       linux@dominikbrodowski.net, ncunningham@crca.org.au
Subject: Re: [patch 3/7] softirq: avoid softirq_work_list for SCHED_SOFTIRQ
 when sent remotely
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100520082309.GH25951@kernel.dk>
References: <1274343159.5605.13325.camel@twins>
	<20100520.011432.209562565.davem@davemloft.net>
	<20100520082309.GH25951@kernel.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 20 May 2010 10:23:09 +0200

> On Thu, May 20 2010, David Miller wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>> Date: Thu, 20 May 2010 10:12:39 +0200
>> 
>> > Most odd all that, Dave, Jens, what happened to all that remote_softirq
>> > stuff?
>> 
>> Nobody ended up using this remote softirq infrastructure, it can be
>> completely deleted.
> 
> What parts of it? There has been reworks of parts of the code since I
> added it, the block layer only uses __smp_call_function_single() to
> trigger remote softirqs.

And that's what the networking is using for RPS/RFS too.
