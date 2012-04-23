Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2DWHKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:10:12 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:53775 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2DWHKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:10:05 -0400
Date: Mon, 23 Apr 2012 09:09:58 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [patch 12/18] s390: Use generic idle thread allocation
Message-ID: <20120423090958.6904ae7b@de.ibm.com>
In-Reply-To: <20120420124557.652574928@linutronix.de>
References: <20120420122120.097464672@linutronix.de>
	<20120420124557.652574928@linutronix.de>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12042307-4966-0000-0000-0000021AFBDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012 13:05:52 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  arch/s390/Kconfig      |    1 +
>  arch/s390/kernel/smp.c |   33 ++-------------------------------
>  2 files changed, 3 insertions(+), 31 deletions(-)

Compile, boots & survives a few rounds of cpu hotplug stress.
Looks good.
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

