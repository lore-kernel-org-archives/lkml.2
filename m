Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab0DIJxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 05:53:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0DIJxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:53:07 -0400
Subject: Re: [PATCH 00/13] mm: preemptibility -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100409105800.0d0f93ac@mschwide.boeblingen.de.ibm.com>
References: <20100408191737.296180458@chello.nl>
	 <20100409105800.0d0f93ac@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 11:53:01 +0200
Message-ID: <1270806781.20295.3297.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 10:58 +0200, Martin Schwidefsky wrote:
> [PATCH] s390: preemptible mmu_gather
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Adapt the stand-alone s390 mmu_gather implementation to the new
> preemptible mmu_gather interface.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com> 


Thanks a lot Martin!

