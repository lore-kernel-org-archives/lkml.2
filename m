Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1E2AYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 20:24:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285Ab1E2AX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 20:23:59 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1105281634440.14257@sister.anvils>
References: <alpine.LSU.2.00.1105281317090.13319@sister.anvils>
 <1306617270.2497.516.camel@laptop> <alpine.LSU.2.00.1105281437320.13942@sister.anvils>
 <BANLkTinsq-XJGvRVmBa6kRp0RTj9NqGWtA@mail.gmail.com> <alpine.LSU.2.00.1105281634440.14257@sister.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 28 May 2011 17:23:36 -0700
Message-ID: <BANLkTi=9qqiLNuo9qbcLoQtK3CKSPnhn4g@mail.gmail.com>
Subject: Re: [PATCH] mm: fix page_lock_anon_vma leaving mutex locked
To: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 5:12 PM, Hugh Dickins <hughd@google.com> wrote:
>
> Though I think I'm arriving at the conclusion that this patch
> is correct as is, despite the doubts that have arisen.

Well, you hopefully saw my second email where I had come to the same conclusion.

So I applied the third patch as well, after all. I think it's at the
very least at least "more correct" than what we have now. Whether that
"page_mapped()" should then be extended to do something else is an
additional thing, and I suspect it would affect the slow-path case
too.

I dunno.

                    Linus
