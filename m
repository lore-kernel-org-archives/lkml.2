Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab0EYNan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:30:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48847 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573Ab0EYNal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:30:41 -0400
Date: Tue, 25 May 2010 23:30:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Gross <mgross@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the viafb tree
Message-Id: <20100525233025.595b49d4.sfr@canb.auug.org.au>
In-Reply-To: <20100525065647.76931339@bike.lwn.net>
References: <20100525125718.703fdc08.sfr@canb.auug.org.au>
	<20100525065647.76931339@bike.lwn.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_May_2010_23_30_25_+1000_ZHDP7jL3zpSgWeWH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_May_2010_23_30_25_+1000_ZHDP7jL3zpSgWeWH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jon,

On Tue, 25 May 2010 06:56:47 -0600 Jonathan Corbet <corbet@lwn.net> wrote:
>
> On Tue, 25 May 2010 12:57:18 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > drivers/media/video/via-camera.c: In function 'viacam_streamon':
> > drivers/media/video/via-camera.c:1032: error: implicit declaration of f=
unction 'pm_qos_add_requirement'
>=20
> Argh.  I should have known that would happen, sorry.  Will fix shortly.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_May_2010_23_30_25_+1000_ZHDP7jL3zpSgWeWH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv70PEACgkQjjKRsyhoI8x5XgCffDOa+6xiCjYCc2zl7a8EXeNV
hV0An1Akd9Od5nTcvn3v8x3x3wNzWLtv
=2ptV
-----END PGP SIGNATURE-----

--Signature=_Tue__25_May_2010_23_30_25_+1000_ZHDP7jL3zpSgWeWH--
