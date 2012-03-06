Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab2CFKDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:03:49 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:53324 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab2CFKDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:03:47 -0500
Date: Tue, 6 Mar 2012 15:33:36 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120306100336.GB14298@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1329764866.2293.376.camhel@twins>
 <20120305152443.GE26559@linux.vnet.ibm.com>
 <20120306091410.GD27238@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120306091410.GD27238@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12030610-8878-0000-0000-0000018E8BD7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2012-03-06 10:14:11]:

> Does volanomark still do yield(),

I could count 3.5M yield() calls across 16 cpus over a period of 5.4sec,
so yes it does seem to make very good use of yeild()!

> thereby invoking a random 
> shuffle of thread scheduling and pretty much voluntarily 
> ejecting itself from most scheduler performance considerations?
> 
> If it uses a real locking primitive such as futexes then its 
> performance matters more.

Good point ..I will gather more data for additional benchmarks
(tbench, sysbench) and post shortly.

- vatsa

