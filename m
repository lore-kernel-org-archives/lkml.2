Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab0FGLit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:38:49 -0400
Received: from [18.85.46.34] ([18.85.46.34]:45169 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab0FGLis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:38:48 -0400
Subject: Re: [PATCH 16/28] sh: Preemptible mmu_gather
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20100607111407.860340332@chello.nl>
References: <20100607110654.606530953@chello.nl>
	 <20100607111407.860340332@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 13:38:39 +0200
Message-ID: <1275910719.1645.560.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 13:07 +0200, Peter Zijlstra wrote:
> Fix up the arm mmu_gahter code to conform to the new API.
> 
urhm,. copy/paste gone wild, clearly that's the SH code for this
patch ;-)

