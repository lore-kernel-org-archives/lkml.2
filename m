Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1ARKpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 05:45:12 -0500
Received: from canuck.infradead.org ([134.117.69.58]:38542 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1ARKpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 05:45:10 -0500
Subject: Re: [PATCH 00/21] mm: Preemptibility -v6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Nick Piggin <npiggin@kernel.dk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <alpine.LSU.2.00.1101172301340.2899@sister.anvils>
References: <20101126143843.801484792@chello.nl>
	 <alpine.LSU.2.00.1101172301340.2899@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 18 Jan 2011 11:44:44 +0100
Message-ID: <1295347484.30950.495.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 23:12 -0800, Hugh Dickins wrote:
> 18/21 mutex-provide_mutex_is_contended.patch
>       I suppose so, though if we use it in the truncate path, then we are
>       stuck with the vm_truncate_count stuff I'd rather hoped would go away;
>       but I guess you're right, that if we did spin_needbreak/need_lockbreak
>       before, then we ought to do this now - though I suspect I only added
>       it because I had to insert a resched-point anyway, and it seemed a good
>       idea at the time to check lockbreak too since that had just been added. 

Like the other missed cleanups now possible, these are things we can
most definitely look at once the dust settles a bit. I just didn't want
to rewrite the world in one go.
