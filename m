Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab2DLWUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:20:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39777 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934771Ab2DLWUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:20:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1204130004080.2542@ionos>
References: <alpine.LFD.2.02.1204130004080.2542@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Apr 2012 15:19:53 -0700
X-Google-Sender-Auth: Y1a1jvF9fJmC_tVk6oSJOPrO5CQ
Message-ID: <CA+55aFxg0rzpL-xCqdScxPKPMupbvteoXD1cPT-fWYpyMXoSGg@mail.gmail.com>
Subject: Re: [GIT pull] timer fixes for 3.4
To: Thomas Gleixner <tglx@linutronix.de>,
        Sasikantha Babu <sasikanth.v19@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 3:06 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> The itimer removal one is not strictly a fix, but I really wanted to
> avoid a rebase of the urgent ones.

Btw, I think that setitimer NULL pointer removal commit is crap.

If people actually do rely on the NULL pointer thing, we're not
"scheduling it for removal". And we most *definitely* aren't
scheduling it for removal for some short timeframe like 3.6.

That's not how ABI's work. If it has become something people rely on,
it now *is* part of the ABI, and no amount of "violates the spec"
matters what-so-ever.

"The spec" is paper - and worthless. What people actually *do* is all
that matters.

                          Linus
