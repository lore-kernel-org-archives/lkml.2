Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1BCPE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:04:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50403 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab1BCPEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:04:53 -0500
Subject: Re: [PATCH 22/25] mm: Convert anon_vma->lock to a mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <20110203142716.93C5.A69D9226@jp.fujitsu.com>
References: <20110125173111.720927511@chello.nl>
	 <20110125174908.372425841@chello.nl>
	 <20110203142716.93C5.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Feb 2011 16:04:55 +0100
Message-ID: <1296745495.26581.370.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 14:27 +0900, KOSAKI Motohiro wrote:
> > Straight fwd conversion of anon_vma->lock to a mutex.
> > 
> > Acked-by: Hugh Dickins <hughd@google.com>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Don't I ack this series at previous iteration? If not, Hmmm.. I haven't remenber
> the reason.

I got a +1 email from you on the spinlock to mutex conversion patch, I
wasn't quite sure to what tag that translated.

>  Anyway
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Is this for this particular patch, or for the series? 
