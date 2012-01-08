Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2AHXYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:24:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36581 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab2AHXYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:24:07 -0500
MIME-Version: 1.0
In-Reply-To: <20120105152035.GA11286@elte.hu>
References: <20120105152035.GA11286@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 Jan 2012 15:23:43 -0800
X-Google-Sender-Auth: ym84S_C1kAeC8QyI_PK1M1m_lEc
Message-ID: <CA+55aFw1emj7YRyp9Z_cH9y-M3BV--X8JPvk+E4jQzMTRCeymQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/platform changes for v3.3
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 7:20 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest x86-platform-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

Ingo, there's something *seriously* wrong with your pull requests.
This is now the third totally buggered pull request I encounter.

This one is also just some stale crap from six months ago with TS-5500
GPIO support etc.

Please. Go back and double-check every single pull request you wrote
for me that I haven't merged yet. In fact, just in case, check the
ones I merged too, just to make sure that I merged what you really
intended me to merge, and not some stale crap. Because you clearly
haven't checked what's actually on the tree on kernel.org.

And while at it, I'd suggest you make your pull request script
actually verify the tree you are asking me to pull, so that this
doesn't continue to happen.

                         Linus
