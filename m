Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab2HXUuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:50:06 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:56520 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933442Ab2HXUuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:50:01 -0400
Date: Fri, 24 Aug 2012 22:49:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Brian Gerst <brgerst@gmail.com>, wbrana <wbrana@gmail.com>,
        Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Daniel Hellstrom <daniel@gaisler.com>
Subject: Re: Drop support for x86-32
Message-ID: <20120824204958.GA22778@merkur.ravnborg.org>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208231814.21168.tweek@tweek.dk> <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com> <CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com> <5037C530.3000408@zytor.com> <20120824185741.GC5094@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824185741.GC5094@thunk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 02:57:41PM -0400, Theodore Ts'o wrote:
> On Fri, Aug 24, 2012 at 11:17:20AM -0700, H. Peter Anvin wrote:
> > 
> > Speaking as one of the x86 maintainers... we are currently deciding the
> > cost/benefit tradeoff around removing i386 support.  I don't mean
> > general x86-32 support, I mean i386 as opposed to i486, Pentium, and so on.
> 
> Random question.  As I recall the Space Shuttle and the International
> Space Station was only using 80386's because they have to be hardened
> against radiation/cosmic rays, as well as all of the other mechnical
> and thermal stresses associated with being in a spacecraft.  Is there
> any newer generation cpu's which are space-cerified at this point?

I do not know if you consider the LEON variants of SPARC 32 bit as a new
generation. But they are actively developed and used in space missions.
At least to my best knowledge.

	Sam
