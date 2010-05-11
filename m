Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab0EKUoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:44:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59296 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab0EKUoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:44:04 -0400
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20100422154059.GA5916@redhat.com>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6>
	 <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6>
	 <20100413183537.GA17538@redhat.com>
	 <20100415093506.GA2064@linux.vnet.ibm.com>
	 <20100419193139.GA24080@redhat.com>
	 <20100420124358.GA20675@linux.vnet.ibm.com>
	 <20100420153023.GA9351@redhat.com>
	 <20100421065948.GA5440@linux.vnet.ibm.com>
	 <20100421160515.GA11321@redhat.com>
	 <20100422133154.GA10776@linux.vnet.ibm.com>
	 <20100422154059.GA5916@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 22:44:00 +0200
Message-ID: <1273610640.1810.103.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 17:40 +0200, Oleg Nesterov wrote:
> 
> Hmm. And if this vma is VM_SHARED, then this bp could be actually
> written to vm_file after mprotect(). 

I don't think we should allow breakpoints on VM_SHARED maps.

