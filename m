Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab2F2QMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab2F2QMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:12:30 -0400
Message-ID: <4FEDD38F.4000601@redhat.com>
Date: Fri, 29 Jun 2012 12:10:55 -0400
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
Subject: Re: [PATCH 11/40] autonuma: define the autonuma flags
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-12-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-12-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:55 AM, Andrea Arcangeli wrote:
> These flags are the ones tweaked through sysfs, they control the
> behavior of autonuma, from enabling disabling it, to selecting various
> runtime options.

That's all fine and dandy, but what do these flags mean?

How do you expect people to be able to maintain this code,
or control autonuma behaviour, when these flags are not
documented at all?

Please document them.

> +enum autonuma_flag {
> +	AUTONUMA_FLAG,
> +	AUTONUMA_IMPOSSIBLE_FLAG,
> +	AUTONUMA_DEBUG_FLAG,
> +	AUTONUMA_SCHED_LOAD_BALANCE_STRICT_FLAG,
> +	AUTONUMA_SCHED_CLONE_RESET_FLAG,
> +	AUTONUMA_SCHED_FORK_RESET_FLAG,
> +	AUTONUMA_SCAN_PMD_FLAG,
> +	AUTONUMA_SCAN_USE_WORKING_SET_FLAG,
> +	AUTONUMA_MIGRATE_DEFER_FLAG,
> +};


-- 
All rights reversed
