Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab0EKUrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:47:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0EKUrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:47:13 -0400
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20100423145813.GA5503@linux.vnet.ibm.com>
References: <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6>
	 <20100413183537.GA17538@redhat.com>
	 <20100415093506.GA2064@linux.vnet.ibm.com>
	 <20100419193139.GA24080@redhat.com>
	 <20100420124358.GA20675@linux.vnet.ibm.com>
	 <20100420153023.GA9351@redhat.com>
	 <20100421065948.GA5440@linux.vnet.ibm.com>
	 <20100421160515.GA11321@redhat.com>
	 <20100422133154.GA10776@linux.vnet.ibm.com>
	 <20100422154059.GA5916@redhat.com>
	 <20100423145813.GA5503@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 22:47:08 +0200
Message-ID: <1273610828.1810.109.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 20:28 +0530, Srikar Dronamraju wrote:
> Again, I am not sure if executable pages should be marked VM_SHARED.
> 
Well, they typically are not, I could imagine some JITs maybe using it,
but those would most probably be shared anonymous.

