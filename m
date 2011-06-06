Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1FFJj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:39:26 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:57462 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1FFJjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:39:25 -0400
Date: Mon, 6 Jun 2011 11:39:22 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] fbdev fixes for 3.0-rc2
Message-ID: <20110606113922.631a9a97@pluto.restena.lu>
In-Reply-To: <20110606091556.GG26101@linux-sh.org>
References: <20110606033900.GF26101@linux-sh.org>
	<BANLkTik1nLG6f27JkR0kBvcJEoqUrq602A@mail.gmail.com>
	<20110606091556.GG26101@linux-sh.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011 18:15:57 Paul Mundt <lethal@linux-sh.org> wrote:
> On Mon, Jun 06, 2011 at 06:04:58PM +0900, Linus Torvalds wrote:
> > On Mon, Jun 6, 2011 at 12:39 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> > >
> > > Bruno Pr??????????????????mont (1):
> > > ?? ?? ??video: Fix use-after-free by vga16fb on rmmod
> > 
> > Do you even *look* at what you ask me to pull from you?
> > 
> > Spend a bit of effort in not sending obviously bogus and corrupted
> > authorship patches. That one has Bruno's name correctly in the
> > sign-off, but you've done something horrible to it in the authorship.
> > 
> That's how I got it from patchwork, so it looks like it was mangled
> already on the way in. I assumed it was just my console that was screwing
> it up, but it looks to be in a similar state in the list archives, too.

Hm, patchwork's mail headers look correct but its post-decoding display
is mangled (hard to guess what multiple transcodings it did!). (your
mail-client also dislikes non-ascii characters)

>From archives, marc.info seems not to handle charsets at all - it dumps
the bytes and flags them as iso-8859-1 (don't know what other archives
you were looking at, marc.info being the only one listed at vger)

The only not so usual thing I see in my From header is that just the
lastname is being encoded and base64 is being used (while
quoted-printable is more common).

Bruno
