Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab0ELNj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:39:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0ELNj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:39:26 -0400
Subject: Re: [PATCH v3 0/10] Uprobes v3
From: Peter Zijlstra <peterz@infradead.org>
To: ananth@in.ibm.com
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100512132708.GC13606@in.ibm.com>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
	 <1273611585.1810.132.camel@laptop>
	 <20100512102518.GA30767@linux.vnet.ibm.com>
	 <1273666385.1626.96.camel@laptop>  <20100512132708.GC13606@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 15:39:20 +0200
Message-ID: <1273671560.1626.114.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 18:57 +0530, Ananth N Mavinakayanahalli wrote:
> Now, as long as we have the housekeeping code to handle the
> possibility of a thread hitting the said breakpoint when its being
> removed, is it safe to assume atomicity for replacing one byte of
> possibly a longer instruction? 

Dunno I'm not a hardware guy, but the issue is so simple to side-step
I'm not sure why you're arguing for relying on these special semantics.



