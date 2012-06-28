Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2F1Oym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 10:54:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59775 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2F1Oyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:54:40 -0400
Message-ID: <1340895238.28750.49.camel@twins>
Subject: Re: [PATCH 13/40] autonuma: CPU follow memory algorithm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 28 Jun 2012 16:53:58 +0200
In-Reply-To: <1340888180-15355-14-git-send-email-aarcange@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
	 <1340888180-15355-14-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 14:55 +0200, Andrea Arcangeli wrote:
> +#ifdef __ia64__
> +#error "NOTE: tlb_migrate_finish won't run here"
> +#endif 

https://lkml.org/lkml/2012/5/29/359

Its an optional thing, not running it isn't fatal at all.

Also, ia64 has CONFIG_NUMA so all this code had better run on it.

That said, I've also already told you to stop using such forceful
migration, that simply doesn't make any sense, numa balancing isn't that
critical.

Unless you're going to listen to feedback I give you, I'm going to
completely stop reading your patches, I don't give a rats arse you work
for the same company anymore.

You're impossible to work with.
