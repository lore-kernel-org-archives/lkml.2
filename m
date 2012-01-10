Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab2AJTO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 14:14:28 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:50664 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700Ab2AJTO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 14:14:26 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Next round of SCSI updates for 3.2 merge window
Date: Tue, 10 Jan 2012 20:13:46 +0100
Message-ID: <6379540.WxJleGASKO@eto>
User-Agent: KMail/4.7.4 (Linux/3.1.0-1.2-desktop; KDE/4.7.4; x86_64; ; )
In-Reply-To: <CA+55aFzR7Qvhoo9QVy-0RzPkqQ=J-DBpLurYSV7azMbQGOJchg@mail.gmail.com>
References: <1325801944.2775.32.camel@dabdike.Larkspurhotels.com> <CA+55aFzR7Qvhoo9QVy-0RzPkqQ=J-DBpLurYSV7azMbQGOJchg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1333682.YmYbM4jU38"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1333682.YmYbM4jU38
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Linus Torvalds wrote:
> On Thu, Jan 5, 2012 at 2:19 PM, James Bottomley
> 
> <James.Bottomley@hansenpartnership.com> wrote:
> > The patch is available here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git#scsi-
> > misc
> No it's not.
> 
> Please fix your crappy script.
> 
> First off, that '#' is wrong. It should be a space.
> 
> Secondly, "master.kernel.org" doesn't support ssh'ing into it any
> more, and can't be used the way you claim I should use it.
> 
> IOW, that thing should have been
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> scsi-misc
> 
> so please fix your script to do that,

And maybe even to get the version number right ;)

Eike
--nextPart1333682.YmYbM4jU38
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk8MjfAACgkQXKSJPmm5/E673gCeL2pQqQpCZnJ5gIS1QCxqMQm2
7d8Anj0GRkcl4+tYaCcwBG3445TJfwhU
=aPIZ
-----END PGP SIGNATURE-----

--nextPart1333682.YmYbM4jU38--

