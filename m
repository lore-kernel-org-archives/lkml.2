Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0CVFe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 01:34:28 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35502 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab0CVFe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 01:34:27 -0400
Date: Mon, 22 Mar 2010 11:04:18 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 9/10] Uprobes Documentation patch
Message-ID: <20100322053418.GB30463@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
 <20100320142638.11427.49335.sendpatchset@localhost6.localdomain6>
 <4BA6DD35.40600@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4BA6DD35.40600@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review, 
The next version of the patchset will address your comments.

> > +
> > +This user-bkpt based version of Uprobes is implemented on the following
> 
> s/bkpt/breakpoint/
> 

Your comment however made me realize that I had used user-bkpt here
rather than user_bkpt.

user_bkpt is a layer that provides breakpoint insertion and removal. 
I wanted to mention that uprobes depends on user_bkpt layer.
I think "This user_bkpt based version" is probably better than
"This user-breakpoint based version"

--
Thanks and Regards
Srikar
