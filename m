Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab2GEMTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:19:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54056 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab2GEMTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:19:14 -0400
Subject: Re: [PATCH 09/40] autonuma: introduce kthread_bind_node()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-kernel@vger.kernel.org,
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20120704231425.GP25743@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
	 <1340888180-15355-10-git-send-email-aarcange@redhat.com>
	 <20120630045013.GB3975@localhost.localdomain>
	 <20120704231425.GP25743@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Jul 2012 14:18:30 +0200
Message-ID: <1341490710.19870.31.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 01:14 +0200, Andrea Arcangeli wrote:
> I can change it to _GPL, drop the EXPORT_SYMBOL or move it inside the
> autonuma code, let me know what you prefer. If I hear nothing I won't
> make changes. 

If I find even a single instance of PF_THREAD_BOUND in your next posting
I'll simply not look at it at all.



