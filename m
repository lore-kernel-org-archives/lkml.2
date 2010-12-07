Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0LGT1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:27:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748Ab0LGT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:27:39 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikTMvBaw+3g3WCNaqoGkDvdiHqbjqDi+M+_A+Yp@mail.gmail.com>
References: <AANLkTinNBVkYRJN+5ne9N4V4oC06Q85FNCZsfw2ZH=Ca@mail.gmail.com> <AANLkTikTMvBaw+3g3WCNaqoGkDvdiHqbjqDi+M+_A+Yp@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Dec 2010 11:27:16 -0800
Message-ID: <AANLkTinfJjPcj1QjrzMtFK4-5d5w4g7_5+QotvMWc3Wc@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc5
To: Tony Luck <tony.luck@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 9:34 AM, Tony Luck <tony.luck@intel.com> wrote:
>
> Counting on my fingers & toes that puts -rc6 on December 13th, and
> since things seem to be going so smoothly in this release

Knock wood.

> we could have 2.6.37 out on the 20th

Not quite _that_ smoothly, I think. We still have the various intel
graphics regressions to fix, and the change to allocate PCI regions
top-down has resulted in some issues. So I doubt I'd be ready to
release 37 before xmas.

And even if it does turn out that I could do the release early, as you
say, I don't really think anybody wants the merge window over the
holidays. So practically speaking I think we'll end up with a quiet
holiday, with the 2.6.37 release happening early January.

Unless something bad happens and I'd need to push it out further.
Which doesn't look all that likely right now, but who knows?

                   Linus
