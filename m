Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2GMWh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 18:37:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2GMWh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 18:37:58 -0400
Date: Fri, 13 Jul 2012 15:37:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Shi <alex.shi@intel.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        rusty@rustcorp.com.au, paul.gortmaker@windriver.com,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: add a few comments of cpumask functions
Message-Id: <20120713153756.78234398.akpm@linux-foundation.org>
In-Reply-To: <4FC38A77.8090700@intel.com>
References: <1338195748-18934-1-git-send-email-alex.shi@intel.com>
	<4FC373D9.7040109@linux.vnet.ibm.com>
	<4FC38277.2030500@intel.com>
	<4FC38A77.8090700@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2012 22:23:51 +0800
Alex Shi <alex.shi@intel.com> wrote:

> Current few cpumask functions' purposes are not quite clear. Stupid
> user like myself need to dig into details for clear function
> purpose and return value.
> Add few explanation for them is helpful.
> 

It appears that Rusty has applied at least some of this patch to
linux-next.  Without reading it ;)

> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -271,6 +271,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
>   * cpumask_test_cpu - test for a cpu in a cpumask
>   * @cpu: cpu number (< nr_cpu_ids)
>   * @cpumask: the cpumask pointer
> + * Returns 1 if the 'cpu' is in the old bitmap of 'cpumask', otherwise returns 0

In kerneldoc we refer to function arguments by prefixing them with a
'@', not by surrounding them with single quotes.  So this should be

* Returns 1 if @cpu is in the old bitmap of @cpumask, otherwise returns 0


And the same applies to the other comments.  So can you please grab the
latest linux-next, prepare a fixup patch and also check that the patch
is complete - not all of your changes have been applied.

