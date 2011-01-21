Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab1AUHjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:39:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:51911 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1AUHjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:39:07 -0500
Subject: Re: [PATCH 00/21] mm: Preemptibility -v6
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, Nick Piggin <npiggin@kernel.dk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <alpine.LSU.2.00.1101201052060.1603@sister.anvils>
References: <20101126143843.801484792@chello.nl>
	 <alpine.LSU.2.00.1101172301340.2899@sister.anvils>
	 <1295457039.28776.137.camel@laptop>
	 <alpine.LSU.2.00.1101201052060.1603@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 18:36:32 +1100
Message-ID: <1295595392.2148.285.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 11:57 -0800, Hugh Dickins wrote:
> 
> But that doesn't preclude lumping them all together for the final
> commit,
> for ease of bisection.  I think Andrew and Ben are the ones to decide
> on that: Ben's bisectability got burnt by THP just now, so he'll have
> strong feelings and good reasons.

I do hate bisectability breakage indeed ... :-)

Cheers,
Ben.

