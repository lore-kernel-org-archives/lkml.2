Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0ENA62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:58:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab0ENA6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:58:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
In-Reply-To: Linus Torvalds's message of  Thursday, 13 May 2010 12:59:23 -0700 <alpine.LFD.2.00.1005131256050.3711@i5.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20100413183537.GA17538@redhat.com>
	<20100415093506.GA2064@linux.vnet.ibm.com>
	<20100419193139.GA24080@redhat.com>
	<20100420124358.GA20675@linux.vnet.ibm.com>
	<20100420153023.GA9351@redhat.com>
	<20100421065948.GA5440@linux.vnet.ibm.com>
	<20100421160515.GA11321@redhat.com>
	<20100422133154.GA10776@linux.vnet.ibm.com>
	<20100422154059.GA5916@redhat.com>
	<1273610723.1810.105.camel@laptop>
	<20100513194034.GA11207@redhat.com>
	<alpine.LFD.2.00.1005131256050.3711@i5.linux-foundation.org>
Emacs: more than just a Lisp interpreter, a text editor as well!
Message-Id: <20100514005651.246A940059@magilla.sf.frob.com>
Date: Thu, 13 May 2010 17:56:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> so arguably it would be good to just make the rule be that you cannot 
> probe a shared mapping. Because whatever you do, it's always the wrong 
> thing.

Agreed.  Or, if you do, it's doing something entirely different and should
be in an interface where you're explicitly attaching it generically to the
file (what's being shared) without regard to any individual process.  But,
as you mentioned, shared, executable mappings are well outside the normal
case and there is no reason to think that a first (or fourth) version of
anything needs to support them at all.


Thanks,
Roland
