Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813Ab2FVArP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 20:47:15 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56801 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760795Ab2FVArN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 20:47:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120621164606.4ae1a71d.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1206201758500.3068@chino.kir.corp.google.com> <20120621164606.4ae1a71d.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Jun 2012 17:46:52 -0700
X-Google-Sender-Auth: PGtVQLokRaUy-39plYNI4nxoYEo
Message-ID: <CA+55aFzPXMD3N3Oy-om6utDCQYmrBDnDgdqpVC5cgKe-v6uZ3w@mail.gmail.com>
Subject: Re: [patch 3.5-rc3] mm, mempolicy: fix mbind() to do synchronous migration
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 4:46 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> I can't really do anything with this patch - it's a bug added by
> Peter's "mm/mpol: Simplify do_mbind()" and added to linux-next via one
> of Ingo's trees.
>
> And I can't cleanly take the patch over as it's all bound up with the
> other changes for sched/numa balancing.

I took the patch, it looked obviously correct (passing in a boolean
was clearly crap).

I wonder if I should make sparse warn about any casts to/from enums.
They tend to always be wrong.

                Linus
