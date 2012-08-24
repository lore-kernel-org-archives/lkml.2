Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030375Ab2HXUjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:39:46 -0400
Received: from vapor.isi.edu ([128.9.64.64]:62617 "EHLO vapor.isi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757675Ab2HXUjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:39:44 -0400
X-Greylist: delayed 1449 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2012 16:39:44 EDT
Date: Fri, 24 Aug 2012 13:18:46 -0700
From: Craig Milo Rogers <rogers@isi.edu>
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Brian Gerst <brgerst@gmail.com>, wbrana <wbrana@gmail.com>,
        Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Space-Certified CPUs and Linux
Message-ID: <20120824201846.GA11418@isi.edu>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208231814.21168.tweek@tweek.dk> <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com> <CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com> <5037C530.3000408@zytor.com> <20120824185741.GC5094@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824185741.GC5094@thunk.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ISI-4-43-8-MailScanner: Found to be clean
X-MailScanner-From: rogers@jib3.isi.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.08.24, Theodore Ts'o wrote:
> Random question.  As I recall the Space Shuttle and the International
> Space Station was only using 80386's because they have to be hardened
> against radiation/cosmic rays, as well as all of the other mechnical
> and thermal stresses associated with being in a spacecraft.  Is there
> any newer generation cpu's which are space-cerified at this point?

	The MAESTRO processor is a rad-hard-by-design variant of the Tilera
architecture, intended for space applications.  Linux runs on it.

	The Mongoose-V is a rad-hard MIPS R3000 processor.  It can run
VxWorks, made by Wind River (a subsidiary of Intel since 2009).

http://www.synova.com/proc/mg5.html

	Rad-hard Power PCs are the current space workhorse.  Several variants
are available.  NASA has run Linux on at least one of them in space, but I
believe that VxWorks is more the norm.

> (Of course, I'm rather doubtful that NASA would ever be willing to use
> Linux on something like the Curiosity Mars Rover, but I could imagine
> Linux being used in a non-mission critcal system on the ISS....)

	Linux has been use on scientific equipment sent to the ISS.
Not, I think, on the avionics.

	Curiosity runs VxWorks, as do the SpaceX Falcon 9 and Dragon.

					Craig Milo Rogers
