Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1BBLN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:13:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:48684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab1BBLN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:13:27 -0500
Subject: Re: Why does the 2.6.37 scheduler hate RT tasks?
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110202011049.GA15084@linux.vnet.ibm.com>
References: <20110202011049.GA15084@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 12:14:25 +0100
Message-ID: <1296645265.26581.307.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 17:10 -0800, Paul E. McKenney wrote:
> Hello, Peter,
> 
> If I create an SCHED_FIFO-priority kthread in pre-2.6.37 kernels,
> things work nicely.  If I try in in later kernels, __disable_runtime()
> gets upset occasionally during CPU-hotplug calls when CPUs are inserted.
> If I make the exact same kthreads run SCHED_NORMAL, no problem.

> PS.  The code at kernel/sched_rt.c:466 is "BUG_ON(want);" in
>      __disable_runtime().  Config attached in case that helps.

Hrmm.. weird.. ok I'll have a look at that.


