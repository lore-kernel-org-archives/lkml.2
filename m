Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab1D1DEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:04:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55895 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab1D1DEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:04:35 -0400
Date: Thu, 28 Apr 2011 13:04:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: large cross tree spelling fixes
Message-Id: <20110428130427.06925753.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Apr_2011_13_04_27_+1000_7XBVg.EGosDj=j=1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Apr_2011_13_04_27_+1000_7XBVg.EGosDj=j=1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Next time you are tempted to take one of these, please resist. :-)

It was not urgent, could have been (at least) broken up and sent to the
respective maintainers, and caused many conflicts in linux-next (which
either means unnecessary rebases/merges or you will see the conflicts
next merge window).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Apr_2011_13_04_27_+1000_7XBVg.EGosDj=j=1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNuNk7AAoJEDMEi1NhKgbsK8cH/j3RfQ6L2nwZuttjRerIXCKm
SiMRGLo22l9VoIVciOPteErd27Eylzqi5/Ulg1rANjpWcOA1G/bqOYYPvaTNqL63
emVSQqnStd2HdsFQ0MPR/OatohJeimlkG9HkcQAZXewzG+VUp42M0wEBAJ6w7/tB
enr4gU5eYKeLwLAoKW/6ZCcsRTBVR3Xv6BAXimgW9k7oePncIyLiabMvAx+UfMk6
sBQYoVeXri1rn91I0ZQkawK/NlWKpGQqYJ/+PUUWgxrlPkVJC3fOG+B+mFnBY+t9
rPnY3ZWrdtP93aqFX2uY8EfIIwwxrReeH32CsQEVM17EJMvVee1JC5Gba/YuIJY=
=EZKh
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Apr_2011_13_04_27_+1000_7XBVg.EGosDj=j=1--
