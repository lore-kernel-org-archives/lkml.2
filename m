Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2CZIgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:36:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2CZIgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:36:08 -0400
Message-ID: <1332750960.16159.81.camel@twins>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Peter Zijlstra <peterz@infradead.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Date: Mon, 26 Mar 2012 10:36:00 +0200
In-Reply-To: <20120322153205.GA28570@linux.vnet.ibm.com>
References: <1329764866.2293.376.camhel@twins>
	 <20120305152443.GE26559@linux.vnet.ibm.com>
	 <20120306091410.GD27238@elte.hu>
	 <20120322153205.GA28570@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 21:02 +0530, Srivatsa Vaddagiri wrote:
> 
> Now the more interesting VM scenario:
> 
More interesting for whoem? I still think virt is an utter waste of
time ;-)

>                 tip     tip + patch
> 
> volano          1       1.29   (29% improvement)
> sysbench [n3]   1       2      (100% improvement)
> tbench 1 [n4]   1       1.07   (7% improvement)
> tbench 8 [n5]   1       1.26   (26% improvement)
> httperf  [n6]   1       1.05   (5% improvement)
> Trade           1       1.31   (31% improvement) 

That smells like there's more to the story, a 100% improvement is too
much..
