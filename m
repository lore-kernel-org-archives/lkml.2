Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab1HXVxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:53:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59428 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1HXVxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:53:07 -0400
Date: Wed, 24 Aug 2011 23:53:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/18] x86/ticketlock: make __ticket_spin_trylock common
Message-ID: <20110824215306.GT25996@one.firstfloor.org>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <c67b46c486c2c2de76c41ba5a012c07fb7659d8e.1314207974.git.jeremy.fitzhardinge@citrix.com> <m2pqjud1fz.fsf@firstfloor.org> <CA+55aFwjJqH0nVDUJ55Eiybm3NTWgHH5pK+SLh=YBW7u0KGP=A@mail.gmail.com> <20110824214334.GS25996@one.firstfloor.org> <4E5571C6.10704@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5571C6.10704@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm, I changed that in this series; arch_spinlock can be 16 bits in the
> <256 case.  I wonder if it matters...

Oh I see.  You could diff pahole listings of the kernel, but I suppose
as Linus said, there will be mainly lots of new holes.

Besides mainstream systems (<= 8S) are steadily marching towards
the 256T barrier.

-Andi
