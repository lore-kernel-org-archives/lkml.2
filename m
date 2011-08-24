Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1HXSEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:04:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45885 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab1HXSEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:04:06 -0400
Subject: Re: [PATCH 00/18] x86: Ticket lock + cmpxchg cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Wed, 24 Aug 2011 20:03:39 +0200
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314209019.6925.53.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 10:52 -0700, Jeremy Fitzhardinge wrote:
> 
>  arch/x86/include/asm/atomic.h         |    4 +-
>  arch/x86/include/asm/atomic64_64.h    |    4 +-
>  arch/x86/include/asm/cacheflush.h     |    2 +-
>  arch/x86/include/asm/cmpxchg.h        |  223 +++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/cmpxchg_32.h     |  128 ++-----------------
>  arch/x86/include/asm/cmpxchg_64.h     |  131 -------------------
>  arch/x86/include/asm/rwsem.h          |   11 +--
>  arch/x86/include/asm/spinlock.h       |  140 +++++++--------------
>  arch/x86/include/asm/spinlock_types.h |   22 +++-
>  arch/x86/include/asm/uv/uv_bau.h      |    4 +-
>  arch/x86/kernel/acpi/boot.c           |   10 +-
>  arch/x86/kernel/cpu/mcheck/mce.c      |    2 +-
>  arch/x86/xen/p2m.c                    |   10 +-
>  13 files changed, 321 insertions(+), 370 deletions(-)

The patches look good to me, and 50 lines less is always nice too!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
