Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2GOMFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 08:05:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46531 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2GOMFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 08:05:02 -0400
Date: Sun, 15 Jul 2012 13:04:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: Re: linux-next: manual merge of the signal tree with the arm-current
 tree
Message-ID: <20120715120457.GJ31729@ZenIV.linux.org.uk>
References: <20120705173526.bf8772adb18edfc91adddea8@canb.auug.org.au>
 <20120705075204.GA12344@flint.arm.linux.org.uk>
 <20120715112735.GI31729@ZenIV.linux.org.uk>
 <CAMuHMdXP_rjwPhfTwcY+Jf3+Dq=AkWtMZvUUibCQ9D=c60_j5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXP_rjwPhfTwcY+Jf3+Dq=AkWtMZvUUibCQ9D=c60_j5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 01:47:59PM +0200, Geert Uytterhoeven wrote:
> Hi Al,
> 
> On Sun, Jul 15, 2012 at 1:27 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Thu, Jul 05, 2012 at 08:52:04AM +0100, Russell King wrote:
> >> Will has concerns with Al's proposed fixes for the signal handling.
> >
> > Could you please resend whatever concerns those had been my way?
> > The last I've seen from Will had been about the stuff in mainline,
> > not in -next; I might have missed something quite easily, though -
> > net.access had been really lousy lately and piles in l-k mbox... ouch.
> 
> Speaking about -next, there's still this fix for an avr32 regression:

Yeah, grabbed it.  Will be in the next rebase (hopefully in a few hours).
