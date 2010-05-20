Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab0ETIOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:14:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34429
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095Ab0ETIOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:14:23 -0400
Date: Thu, 20 May 2010 01:14:32 -0700 (PDT)
Message-Id: <20100520.011432.209562565.davem@davemloft.net>
To: peterz@infradead.org
Cc: suresh.b.siddha@intel.com, mingo@elte.hu, tglx@linutronix.de,
       arjan@linux.jf.intel.com, venki@google.com, svaidy@linux.vnet.ibm.com,
       ego@in.ibm.com, linux-kernel@vger.kernel.org,
       linux@dominikbrodowski.net, ncunningham@crca.org.au,
       jens.axboe@oracle.com
Subject: Re: [patch 3/7] softirq: avoid softirq_work_list for SCHED_SOFTIRQ
 when sent remotely
From: David Miller <davem@davemloft.net>
In-Reply-To: <1274343159.5605.13325.camel@twins>
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
	<20100517184027.777058425@sbs-t61.sc.intel.com>
	<1274343159.5605.13325.camel@twins>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 20 May 2010 10:12:39 +0200

> Most odd all that, Dave, Jens, what happened to all that remote_softirq
> stuff?

Nobody ended up using this remote softirq infrastructure, it can be
completely deleted.
