Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1KDMzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:55:48 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54296 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab1KDMzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:55:47 -0400
Date: Fri, 4 Nov 2011 18:20:01 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH] perf bench sched cpu-matrix benchmark
Message-ID: <20111104125001.GC11217@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20111104115620.GA25704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111104115620.GA25704@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11110412-3534-0000-0000-00000141812E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> [2011-11-04 17:26:20]:

> +/*
> + * Prints the progress of multipilcations done by all threads

Fix typo: 
	s/multipilcations/multiplications

> + * every sleep_msec
> + */
> +static void print_progress(struct thread_work *work, int thread_count)

We should perhaps add 'sleep_msec' argument to this function.

- vatsa

