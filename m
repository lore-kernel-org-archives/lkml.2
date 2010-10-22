Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab0JVCAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 22:00:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287Ab0JVCAH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 22:00:07 -0400
MIME-Version: 1.0
In-Reply-To: <201010220050.o9M0ognt032167@hera.kernel.org>
References: <201010220050.o9M0ognt032167@hera.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Oct 2010 18:59:16 -0700
Message-ID: <AANLkTi=2tPU6qwuoOEfS7NfsNX+7vCYhvkHzNOcx4Gf3@mail.gmail.com>
Subject: Re: [GIT PULL] memblock for 2.6.37
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        CAI Qian <caiqian@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Felipe Balbi <balbi@ti.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        ext Grazvydas Ignotas <notasas@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 5:50 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> The unmerged branch is at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-memblock-for-linus
>
> The premerged branch is at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-memblock-for-linus-merged

I always tend to take the unmerged version, because I want to see what
the conflicts are (it gives me some view of what clashes), but when
people do pre-merges I then try to compare my merge against theirs.

However, in this case, your pre-merged version differs. But I think
it's your merge that was incorrect. You left this line:

   obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o

in kernel/Makefile, even though kernel/early_res.c is gone.

I'll push out my merge, but please do verify that it all looks ok.

                               Linus
