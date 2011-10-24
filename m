Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab1JXQ4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 12:56:02 -0400
Received: from mailsrv14.zmi.at ([212.69.164.54]:60117 "EHLO mailsrv14.zmi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab1JXQ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 12:56:00 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Oct 2011 12:56:00 EDT
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Organization: it-management http://it-management.at
To: xfs@oss.sgi.com
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
Date: Mon, 24 Oct 2011 18:45:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.3-zmi; KDE/4.6.0; x86_64; ; )
Cc: jesper@krogh.cc, Christoph Hellwig <hch@infradead.org>, aradford@gmail.com,
        linux-kernel@vger.kernel.org
References: <20111011091757.GA32589@otto.nzcorp.net> <20111011133448.GA10692@infradead.org> <e78a7c38af135cee4b742c99ecd1c011.squirrel@shrek.krogh.cc>
In-Reply-To: <e78a7c38af135cee4b742c99ecd1c011.squirrel@shrek.krogh.cc>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1887112.sravnr3J3p";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201110241845.44463@zmi.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1887112.sravnr3J3p
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 17. Oktober 2011 jesper@krogh.cc wrote:
> Over the weekend, we have run memtest for 4 hours (50% of the
> complete tests according to memtest) and it didnt find anything.

This is a bit OT, but you *must* run at least one full loop of memtest=20
in order to have significant output. I've had PCs that only broke on=20
test 7, and sometimes even a PC could run 2-3 loops before a bad bit was=20
found on the 4th loop or so. Only if there's a nasty error, like a=20
physically broken mainboard, you'll gets errors quickly.

Despite that, I think your problem is not memory based, as you said you=20
use ECC, and I'd believe you've turned on background scrubbing.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1887112.sravnr3J3p
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk6lljgACgkQzhSR9xwSCbQmIwCcC1K76s65zfCBCXtiXmAx5Hms
tPsAmQGA+qWyjULB2R2eX3W8xGGLt8U1
=IXhx
-----END PGP SIGNATURE-----

--nextPart1887112.sravnr3J3p--
