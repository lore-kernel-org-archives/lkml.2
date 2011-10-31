Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab1JaITU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 04:19:20 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33895 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417Ab1JaITR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 04:19:17 -0400
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
References: <20111026202235.GA20928@havoc.gtf.org>
	 <1319969101.5215.20.camel@dabdike>
	 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 12:19:10 +0400
Message-ID: <1320049150.8283.19.camel@dabdike>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-30 at 10:12 -0700, Linus Torvalds wrote:
> On Sun, Oct 30, 2011 at 3:05 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > You can fix this by using mime and detached signatures as well but I
> > wouldn't worry too much about it.  What emerged at KS is that Linus uses
> > gmail and gmail has no integration with pgp, thus pgp signing of pull
> > requests is superfluous since Linus won't add the steps of saving the
> > message to a text file and manually running pgp over it to verify
> > because of the huge elongation in workflow this causes especially during
> > a merge window.
> 
> Actually, I have been running "gpg --verify" on the email that use the
> standard PGP encapsulation (ie the kind that Jeff used, that has
> "-----BEGIN PGP SIGNED MESSAGE-----" in it.
> 
> It's the rfc3516-type email (aka protocol="application/pgp-encrypted")
> type that I can't even verify, because that's not something that gpg
> knows inherently how to check: you have to decode the message the
> right way and know what the rules are, and I have no intention of
> trying to figure it out. I have yet to find any usable tool that is
> able to check it, and I'm certainly not going to waste time trying to
> parse the rfc and write my own.

OK, so I get clearly no partial PGP messages and no using rfc3516
formatted pgp mail.

> That said, even the "BEGIN PGP SIGNED MESSAGE" things are a massive
> pain in the butt. We need to automate this some sane way, both for the
> sender and for the recipient.

But this doesn't help with what practise you want us to follow.  Do you
want us to send full signed email using pgp encapsulation for pull
requests in spite of the mangling it does to attached patches and the
amount of extra pain it causes you?  Or is relying on looking at the
received headers and always using public email lists to detect spoofing
by revocation OK until we find a mechanism for integrating pgp into git?

James


