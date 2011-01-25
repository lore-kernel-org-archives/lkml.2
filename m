Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab1AYUh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:37:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104Ab1AYUh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:37:26 -0500
MIME-Version: 1.0
In-Reply-To: <1295987461.28776.1110.camel@laptop>
References: <20110125173111.720927511@chello.nl> <20110125174908.262260777@chello.nl>
 <AANLkTikchW7Z6mSgcbt7wn9DWTeEGrKwfMwj1_WjMB5c@mail.gmail.com> <1295987461.28776.1110.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Jan 2011 06:37:00 +1000
Message-ID: <AANLkTim_eF4xapv=4rSo=p5_KLGiHh315C=8CKCT-S9=@mail.gmail.com>
Subject: Re: [PATCH 20/25] mm: Simplify anon_vma refcounts
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 6:31 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> It relies on patch 19, which moves the anon_vma refcount out from under
> CONFIG_goo.
>
> If however you like it, I can move 19 and this patch up to the start and
> have that go your way soon.

So I'd prefer that, and keeping this issue separate. It seems like a
rather independent cleanup to me (there may be others, this is the
only one I reacted to when skimming through the series - reading email
using my small laptop screen and a somewhat flaky 3g hotspot
connection isn't exactly amenable to deep and careful thinking ;).

             Linus
