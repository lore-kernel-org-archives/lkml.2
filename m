Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab2AFWNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 17:13:47 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41290 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab2AFWNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 17:13:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120105144757.GA6043@elte.hu>
References: <20120105144757.GA6043@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jan 2012 14:13:21 -0800
X-Google-Sender-Auth: 9mLsPw66x69cRPToTIuWErvnKfk
Message-ID: <CA+55aFzzpMSoRdmqFT7gnH3On43qj8ZVz7C8Dpw6dHB18jtyqw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/debug changes for v3.3
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 6:47 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest x86-debug-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus

Hell no!

Why do you send me this sh*t? The "Use NMI instead of REBOOT_VECTOR"
commit has been reported to not work AT ALL.

It was totally broken - Don Zickus sent out the email to fix the
completely bogus parenthesis in that commit just a day ago - yet you
send me this KNOWN BROKEN CRAP.

And yes, I checked. The version you sent me is the f*cked one. I was
hoping that you would have fixed it up. But no.

In short, you didn't merge the fix, and yet you sent me a patch series
that was *known* to be broken for the last three+ weeks! And I know
you were cc'd on the report, which was in the same thread as the
automatic tip-bot message for the particular broken commit, so the
particular broken commit that introduced it was well-known.

So that thing has been known broken since before Christmas, and was
due to a major typo that made a "atomic_cmpxchg()" not work *at*all* -
yet you blithely send me this crap.

Why? WHAT THE F*CK HAPPENED, INGO?

Yes, I'm angry as hell. Shit like this should NOT happen.  I don't
want people sending me known-buggy pull requests.

                        Linus
