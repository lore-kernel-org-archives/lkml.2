Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab1CIMjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:39:13 -0500
Received: from mout.perfora.net ([74.208.4.195]:62561 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab1CIMjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:39:10 -0500
Date: Wed, 9 Mar 2011 07:38:34 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Roland McGrath <roland@redhat.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm: use mm_struct to resolve gate vma's in
	__get_user_pages
Message-ID: <20110309123834.GA8236@fibrous.localdomain>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca> <1299631343-4499-2-git-send-email-wilsons@start.ca> <20110309141208.03F7.A69D9226@jp.fujitsu.com> <20110309060617.GB22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309060617.GB22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:AFzWxr9yuKRady11NkiVoYPkXaQ9F64f4HmM2NQKgue
 eKDfZLQ7kHwIj92Xz8kKGdFts0qYMApPKzq/rWKcsBeElM6Br8
 3wqqQMIR0iXJDtdko6e0l4nI3CxEIS4giMMfQ+9Yuw4s1fzCP4
 PgB7pqeq+ApFJvfGUHees0j5oEMU9AF+txhKE1nxw0r0ujETrh
 9R4ZuFRmCKvQ3r8mgSqUsNVC0g2ZHk6WtYSb+DnQ2k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 06:06:17AM +0000, Al Viro wrote:
> On Wed, Mar 09, 2011 at 02:19:30PM +0900, KOSAKI Motohiro wrote:
> 
> > Hmm..
> > Is this works? In exec() case task has two mm, old and new-borned. tsk has
> > no enough information to detect gate area if 64bit process exec 32bit process
> > or oppsite case. On Linux, 32bit and 64bit processes have perfectly different
> > process vma layout.
> > 
> > Am I missing something?
> 
> Patch series refered to in [0/6] ;-)  FWIW, that would probably be better
> off as one mail thread - would be easier to find.

OK.  After the first half has gone thru review I will respin (with changes)
as a single series.  I was actually hoping the split would make review a
little bit easier, but in retrospect I could have accomplished the same
thing by simply pointing out the two halves in the series "cover
letter".


-- 
steve

