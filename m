Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab0EMWNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:13:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41776 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759530Ab0EMWM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:12:59 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
From: Andi Kleen <andi@firstfloor.org>
References: <20100413183537.GA17538@redhat.com>
	<20100415093506.GA2064@linux.vnet.ibm.com>
	<20100419193139.GA24080@redhat.com>
	<20100420124358.GA20675@linux.vnet.ibm.com>
	<20100420153023.GA9351@redhat.com>
	<20100421065948.GA5440@linux.vnet.ibm.com>
	<20100421160515.GA11321@redhat.com>
	<20100422133154.GA10776@linux.vnet.ibm.com>
	<20100422154059.GA5916@redhat.com> <1273610723.1810.105.camel@laptop>
	<20100513194034.GA11207@redhat.com>
	<alpine.LFD.2.00.1005131256050.3711@i5.linux-foundation.org>
Date: Fri, 14 May 2010 00:12:52 +0200
In-Reply-To: <alpine.LFD.2.00.1005131256050.3711@i5.linux-foundation.org> (Linus Torvalds's message of "Thu\, 13 May 2010 12\:59\:23 -0700 \(PDT\)")
Message-ID: <87tyqbbgd7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> so arguably it would be good to just make the rule be that you cannot 
> probe a shared mapping. Because whatever you do, it's always the wrong 
> thing.

But isn't text usually shared?  I don't see how you could set any
break points or jump probes on text pages with that restriction.

BTW there were old patches for NUMA text duplication, maybe they could
be resurrected for that too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
