Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab2F2UtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:49:03 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47662 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab2F2UtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:49:01 -0400
Date: Fri, 29 Jun 2012 22:48:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>,
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
Subject: Re: [PATCH 21/40] autonuma: avoid CFS select_task_rq_fair to return
 -1
Message-ID: <20120629204855.GA4316@gmail.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
 <1340888180-15355-22-git-send-email-aarcange@redhat.com>
 <4FEDFAB1.8050305@redhat.com>
 <1340996749.28750.125.camel@twins>
 <4FEDFD0F.7070207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEDFD0F.7070207@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> On 06/29/2012 03:05 PM, Peter Zijlstra wrote:
> >On Fri, 2012-06-29 at 14:57 -0400, Rik van Riel wrote:
> >>Either this is a scheduler bugfix, in which case you
> >>are better off submitting it separately and reducing
> >>the size of your autonuma patch queue, or this is a
> >>behaviour change in the scheduler that needs better
> >>arguments than a 1-line changelog.
> >
> >I've only said this like 2 or 3 times.. :/
> 
> I'll keep saying it until Andrea has fixed it :)

But that's just wrong - patch submitters *MUST* be responsive 
and forthcoming. Mistakes are OK, but this goes well beyond 
that. A patch-queue must generally not be resubmitted for yet 
another review round, as long as there are yet unaddressed 
review feedback items.

The thing is, core kernel code maintainers like PeterZ don't 
scale and the number of patches to review is huge - yet Andrea 
keeps wasting Peter's time with the same things again and 
again... How much is too much?

Thanks,

	Ingo
