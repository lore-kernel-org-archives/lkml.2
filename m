Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab2KAVDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:03:30 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38824 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760172Ab2KAVDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:03:25 -0400
Message-ID: <1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Date: Thu, 01 Nov 2012 21:03:20 +0000
In-Reply-To: <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <2548314.3caaFsMVg6@linux-lqwf.site> <50919EED.3020601@genband.com>
	 <36538307.gzWq1oO7Kg@linux-lqwf.site>
	 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	 <1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
	 <CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
	 <1351783096.2391.77.camel@dabdike.int.hansenpartnership.com>
	 <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-01 at 13:50 -0400, Eric Paris wrote:
> On Thu, Nov 1, 2012 at 11:18 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> 
> > You're completely confusing two separate goals:
> >
> >      1. Is it possible to use secure boot to implement a security policy
> >         on Linux
> >      2. What do we have to do anything to prevent Linux being used to
> >         attack windows which may lead to a revocation of the distro
> >         signing key.
> >
> > "untrusted root" is a silly answer to 1 because it's incredibly
> > difficult to remove sufficient trust from root and still have it be
> > trusted enough to be effective as root.  The trust bound up in root is
> > incredibly intertwined.  It would be far better to start by eliminating
> > the root user altogether and building up on the capabilities in a
> > granular fashion for this type of lockdown.
> 
> granular lockdown!?  sounds like SELinux.  But that certainly can't
> solve the problems here...
> 
> I think your premise has a couple of problems.  First is how you chose
> to word #2.  Lets reword it as:
> 
> What do we have to do to prevent Linux being used to attack Linux
> which may lead to secure boot being useless.

That's not really remotely related, is it?  Microsoft doesn't really
care about Linux on Linux attacks, so preventing or allowing them isn't
going to get a distro key revoked.


> If we accept that as #2, then we think, "What makes secure boot
> useless"  or "What is the security goal as envisioned by secure boot."
>  The goal of secure boot is to implement an operating system which
> prevents uid==0 to ring 0 escalation.  That is the security policy
> secure boot needs to not be completely useless.  And as it turns out,
> that security policy is useful in other situations.

Um, so all that is a rewording of what I said in 1 ... how do you take
advantage of secure boot, so you're re-conflating the issues.

Snip the rest because it doesn't really make sense in terms of getting
the key revoked.

James


