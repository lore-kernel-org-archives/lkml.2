Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab2F2Szv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:55:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab2F2Szu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:55:50 -0400
Message-ID: <4FEDF9D4.2080504@redhat.com>
Date: Fri, 29 Jun 2012 14:54:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 20/40] autonuma: alloc/free/init mm_autonuma
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-21-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-21-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:56 AM, Andrea Arcangeli wrote:
> This is where the mm_autonuma structure is being handled. Just like
> sched_autonuma, this is only allocated at runtime if the hardware the
> kernel is running on has been detected as NUMA. On not NUMA hardware
> the memory cost is reduced to one pointer per mm.
>
> To get rid of the pointer in the each mm, the kernel can be compiled
> with CONFIG_AUTONUMA=n.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>

Same comments as before.  A description of what the data
structure is used for and how would be good.

-- 
All rights reversed
