Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab2GBFPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 01:15:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab2GBFPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 01:15:38 -0400
Message-ID: <4FF12E56.4060303@redhat.com>
Date: Mon, 02 Jul 2012 01:15:02 -0400
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
Subject: Re: [PATCH 38/40] autonuma: autonuma_migrate_head[0] dynamic size
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-39-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-39-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:56 AM, Andrea Arcangeli wrote:
> Reduce the autonuma_migrate_head array entries from MAX_NUMNODES to
> num_possible_nodes() or zero if autonuma_impossible() is true.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>

This could be merged into, or fitted into the series right after
patch 15. Having a dozen other patches in-between makes reviewing
much harder than it should have to be.


-- 
All rights reversed
