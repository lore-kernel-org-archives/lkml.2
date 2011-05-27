Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab1E0BBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:01:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42920 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab1E0BBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:01:32 -0400
Date: Fri, 27 May 2011 11:01:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: netdev <netdev@vger.kernel.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sjur Braendeland <sjur.brandeland@stericsson.com>
Subject: Re: linux-next: Tree for May 26 (drivers/net/caif)
Message-Id: <20110527110123.aa7bbf38.sfr@canb.auug.org.au>
In-Reply-To: <20110526120702.fac24de0.randy.dunlap@oracle.com>
References: <20110526163941.7dfcad1a.sfr@canb.auug.org.au>
	<20110526120702.fac24de0.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_May_2011_11_01_23_+1000_.VEzsBB=fLbj/9kn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_May_2011_11_01_23_+1000_.VEzsBB=fLbj/9kn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Thu, 26 May 2011 12:07:02 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> drivers/net/caif/caif_serial.c:194: warning: 'return' with no value, in f=
unction returning non-void
> drivers/net/caif/caif_serial.c:202: warning: 'return' with no value, in f=
unction returning non-void
>=20
> I'm curious:  how do warnings like this get overlooked?
> too much noise in the build messages?  or it wasn't overlooked, just igno=
red?

For me, too much noise :-(  I catch some, but not all.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_May_2011_11_01_23_+1000_.VEzsBB=fLbj/9kn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3vfjAAoJEDMEi1NhKgbsTRQH/15X6YP1AFGnVUhRDsXB+TY8
RhNP/g8DxcRjtilNZnLLZoS3+47KKQ7YVuDTs80T97GVUh/pfiNnqWsOtLHWCtb7
lA5EgJUaVCm+nRhkyIcVLqhvMRxl+vnQ+bXxxXbI9EsFCv1LuIHWzPykb6qP9hsZ
zqejUq88Nu4ASsDEn1aTyV2dytL/0P/f9oRvjHDU3jogYcOD9Umw/FKdZ2Cn8BSL
tuI7/1iBkFeUlRhvSlMTz20VdQJp3N1UpkKjQLsfjkR3xuw8VC5pa1wI0hh/h9Iw
37qkAf1wR+5EHu8lgA2etLaCz25NLlPKLKMeCRpFmLHi9nCtgMYFsmdjXX0LEUI=
=BZIt
-----END PGP SIGNATURE-----

--Signature=_Fri__27_May_2011_11_01_23_+1000_.VEzsBB=fLbj/9kn--
