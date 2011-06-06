Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1FFJQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:16:06 -0400
Received: from linux-sh.org ([111.68.239.195]:37548 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab1FFJQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:16:03 -0400
Date: Mon, 6 Jun 2011 18:15:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] fbdev fixes for 3.0-rc2
Message-ID: <20110606091556.GG26101@linux-sh.org>
References: <20110606033900.GF26101@linux-sh.org> <BANLkTik1nLG6f27JkR0kBvcJEoqUrq602A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik1nLG6f27JkR0kBvcJEoqUrq602A@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 06:04:58PM +0900, Linus Torvalds wrote:
> On Mon, Jun 6, 2011 at 12:39 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> >
> > Bruno Pr??????????????????mont (1):
> > ?? ?? ??video: Fix use-after-free by vga16fb on rmmod
> 
> Do you even *look* at what you ask me to pull from you?
> 
> Spend a bit of effort in not sending obviously bogus and corrupted
> authorship patches. That one has Bruno's name correctly in the
> sign-off, but you've done something horrible to it in the authorship.
> 
That's how I got it from patchwork, so it looks like it was mangled
already on the way in. I assumed it was just my console that was screwing
it up, but it looks to be in a similar state in the list archives, too.

In any event, I've fixed it up and pushed out a cleaned up version, sorry
for the noise.
