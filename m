Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab2HVTZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:25:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758866Ab2HVTZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:25:25 -0400
Message-ID: <5035325C.3070909@redhat.com>
Date: Wed, 22 Aug 2012 15:26:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
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
Subject: Re: [PATCH 00/36] AutoNUMA24
References: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
In-Reply-To: <1345647560-30387-1-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 10:58 AM, Andrea Arcangeli wrote:
> Hello everyone,
>
> Before the Kernel Summit, I think it's good idea to post a new
> AutoNUMA24 and to go through a new review cycle. The last review cycle
> has been fundamental in improving the patchset. Thanks!

Thanks for improving the code and incorporating all our
feedback. The AutoNUMA codebase is now in a state where
I can live with it.

I hope the code will be acceptable to others, too.

> The objective of AutoNUMA is to be able to perform as close as
> possible to (and sometime faster than) the NUMA hard CPU/memory
> bindings setups, without requiring the administrator to manually setup
> any NUMA hard bind.

It is a difficult problem, but the performance numbers
I have seen before (with older versions) seem to suggest
that AutoNUMA is accomplishing the goal.
