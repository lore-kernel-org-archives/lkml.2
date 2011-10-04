Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716Ab1JDUaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:30:35 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56643 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114Ab1JDUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:30:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Adrian Bunk <bunk@stusta.de>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: Your message of "Mon, 03 Oct 2011 21:04:41 +0300."
             <20111003180441.GD3072@localhost.pp.htv.fi>
From: Valdis.Kletnieks@vt.edu
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl> <4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <20111003093239.GB25136@localhost.pp.htv.fi> <y0mobxyjazi.fsf@fche.csb>
            <20111003180441.GD3072@localhost.pp.htv.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317760188_10919P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Oct 2011 16:29:48 -0400
Message-ID: <34045.1317760188@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4E8B6CBF.0092,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317760188_10919P
Content-Type: text/plain; charset=us-ascii

On Mon, 03 Oct 2011 21:04:41 +0300, Adrian Bunk said:
> On Mon, Oct 03, 2011 at 12:28:17PM -0400, Frank Ch. Eigler wrote:

> > What is the threat that this passport checking is intended to cure?
> > That someone else might have been impersonating Rafael for years,
> > sending patches, chatting in email and over the phone, and attending
> > conferences?
>
> Key signing is an identity check.

That's dodging the issue. Somehow, I don't see Andrew Morton asking Linus to
sign his key, and Linus saying "How do I know you're the *real* Andrew Morton?"
And Andrew is a clever guy, if he was a fake Andrew, I'm sure he'd have gotten
a fake ID that would be good enough to fool Linus, who is also a clever guy but
I'm not aware of any special background he has in forgery detection. ;)

The more important point is that as far as the linux-kernel community is
concerned, the guy we've all seen show up at conferences and present stuff all
these times *is* Andrew Morton, even if his real name is George Q. Smith and
he's been on the run for the last 27 years for an embarassing incident
involving an ostrich, the mayor's daughter, and 17 gallons of mineral oil in
the atrium of the museum. ;)

The ID check is  to connect an actual person to the claimed key, and primarily
intended for key signing parties and the like, where people *don't* know each
other very well. I think there's something like 5 people on the linux-kernel
list who actually know me in real life, because I don't travel much and I'm
rather in the boonies.  If I asked anybody *else* who I'd not met before to
sign my key, yes, I'd expect them to check my ID, to ensure I wasn't somebody
trying to pull a fast one at the keysigning party.

> > If so, perhaps the impostor is of more value to the
> > project than the Real Rafael.
> 
> Pseudonymous contributions to the kernel are not allowed.

See above - whoever Andrew Morton *really* is, his contributions are hardly
pseudonymous.


--==_Exmh_1317760188_10919P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOi2y8cC3lWbTT17ARAuzBAJ0b8yart0YKRHcG44UZ0Yn/4KyamQCdHO6c
JOpVRfEeoq3QMM0jhQOB7IE=
=i/Fd
-----END PGP SIGNATURE-----

--==_Exmh_1317760188_10919P--

