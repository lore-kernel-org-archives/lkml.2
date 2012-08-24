Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab2HXS5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:57:53 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:46661 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab2HXS5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:57:49 -0400
Date: Fri, 24 Aug 2012 14:57:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Brian Gerst <brgerst@gmail.com>, wbrana <wbrana@gmail.com>,
        Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
Message-ID: <20120824185741.GC5094@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
	wbrana <wbrana@gmail.com>, Martin Nybo Andersen <tweek@tweek.dk>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
 <201208231814.21168.tweek@tweek.dk>
 <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
 <CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com>
 <5037C530.3000408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5037C530.3000408@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 11:17:20AM -0700, H. Peter Anvin wrote:
> 
> Speaking as one of the x86 maintainers... we are currently deciding the
> cost/benefit tradeoff around removing i386 support.  I don't mean
> general x86-32 support, I mean i386 as opposed to i486, Pentium, and so on.

Random question.  As I recall the Space Shuttle and the International
Space Station was only using 80386's because they have to be hardened
against radiation/cosmic rays, as well as all of the other mechnical
and thermal stresses associated with being in a spacecraft.  Is there
any newer generation cpu's which are space-cerified at this point?

(Of course, I'm rather doubtful that NASA would ever be willing to use
Linux on something like the Curiosity Mars Rover, but I could imagine
Linux being used in a non-mission critcal system on the ISS....)

      	      		    	    	      - Ted
