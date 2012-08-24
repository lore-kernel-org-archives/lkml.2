Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab2HXT7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:59:10 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:46668 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab2HXT7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:59:07 -0400
Date: Fri, 24 Aug 2012 15:58:56 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        wbrana <wbrana@gmail.com>, Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
Message-ID: <20120824195856.GD5094@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
	wbrana <wbrana@gmail.com>, Martin Nybo Andersen <tweek@tweek.dk>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
 <201208231814.21168.tweek@tweek.dk>
 <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com>
 <CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com>
 <5037C530.3000408@zytor.com>
 <20120824185741.GC5094@thunk.org>
 <20120824201358.0f086c9a@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824201358.0f086c9a@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 08:13:58PM +0100, Alan Cox wrote:
> > (Of course, I'm rather doubtful that NASA would ever be willing to use
> > Linux on something like the Curiosity Mars Rover, but I could imagine
> > Linux being used in a non-mission critcal system on the ISS....)
> 
> GOAS, RACSI... not entirely non-mission critical stuff either.
> 
> And the ST8 project covers Linux 

BTW, it turns out I was wrong about Linux being used on Mars.
Apparently Linux was used on the Mars Global Surveyor, as well as the
Sprit and Opportunity rovers -- and they were indeed using
space-hardened i386's from Intel.

							- Ted
