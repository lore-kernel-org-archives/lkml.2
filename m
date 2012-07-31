Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2GaGFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:05:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47325 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab2GaGFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:05:39 -0400
Date: Tue, 31 Jul 2012 09:05:36 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: David Rientjes <rientjes@google.com>
cc: shuah.khan@hp.com, cl@linux.com, glommer@parallels.com, js1304@gmail.com,
        shuahkhan@gmail.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
In-Reply-To: <alpine.DEB.2.00.1207301904520.24929@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1207310904370.2380@tux.localdomain>
References: <1342221125.17464.8.camel@lorien2> <CAOJsxLGjnMxs9qERG5nCfGfcS3jy6Rr54Ac36WgVnOtP_pDYgQ@mail.gmail.com> <alpine.DEB.2.00.1207301255320.24196@chino.kir.corp.google.com> <CAOJsxLHw8G0ChnOeBv1nNr3tqNPPjdnkY=RStyo3rRqC1bdDAA@mail.gmail.com>
 <alpine.DEB.2.00.1207301904520.24929@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2012, David Rientjes wrote:
> So much for compromise, I thought we had agreed that at least some of the 
> checks for !name, in_interrupt() or bad size values should be moved out 
> from under the #ifdef CONFIG_DEBUG_VM, but this wasn't done.  This 
> discussion would be irrelevent if we actually did what we talked about.

I didn't want to change the checks at the last minute and invalidate 
testing in linux-next but I'm more than happy to merge such a patch when 
the merge window closes.

			Pekka
