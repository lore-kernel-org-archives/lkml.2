Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab0GTAPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:15:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754365Ab0GTAPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:15:39 -0400
MIME-Version: 1.0
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
Date: Mon, 19 Jul 2010 17:14:29 -0700
Message-ID: <AANLkTimC5Yio93MQ3QPjat_vpOp4gKkV_p1hmI-Nvl3B@mail.gmail.com>
Subject: Re: [PATCH -v25 00/49] Use memblock with x86
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 4:56 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> New memblock could be used to replace early_res in x86.
>
> Suggested by: David, Ben, and Thomas

So how is this related to Ben's git tree that was tested on sparc? Not
clear from the changelog.

> First two patches are needed for 2.6.35. need to be applied at first.

Please send those two as a separate series with a separate cover-sheet
and explanation. If they are regressions or major fixes for existing
code, they should not go into some 50-patch series for the future.
That way they just get lost in the noise, and it's not at all as clear
that they are important for current kernels.

In fact, in general, the fewer 50-series patches we see, the better.
If a series of 50 patches could be split up into separate independent
series ("independent" in the sense that they do different things -
maybe one series depends on another series for infrastructure, but
then actually concentrates on a different issue), that would be good.

Because, quite frankly, when I get email-bombed by tens of patches, I
immediately lose about 99% of my eagerness to actually check the
patches out. And I bet I'm not the only one. So it would likely be
much more productive if these kinds of things can be sent out as
multiple smaller series that can be looked at separately (and not sent
out at the same time).

Ok?

          Linus
