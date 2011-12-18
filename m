Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1LRAnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 19:43:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34701 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab1LRAnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 19:43:12 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1112180128070.21784@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1112180128070.21784@swampdragon.chaosbits.net>
Date: Sat, 17 Dec 2011 16:43:11 -0800
Message-ID: <CANN689GQyzMGfnxsKmni7wDFpqo4s=D3dpu6w9UxN0tKbqakig@mail.gmail.com>
Subject: Re: [PATCH] Use 'do {} while (0)' for empty flush_tlb_fix_spurious_fault()
 macro
From: Michel Lespinasse <walken@google.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: x86@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 4:32 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> If one builds the kernel with -Wempty-body one gets this warning:
>
>  mm/memory.c:3432:46: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
>
> due to the fact that 'flush_tlb_fix_spurious_fault' is a macro that
> can sometimes be defined to nothing.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Looks good to me. I'd be happy with either that or Al's alternative suggestion.

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
