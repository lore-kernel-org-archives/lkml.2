Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1CNGGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 02:06:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43979 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab1CNGGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 02:06:01 -0400
Date: Mon, 14 Mar 2011 17:05:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, peterz@infradead.org
Subject: Re: linux-next: build failure after merge of the net tree
Message-Id: <20110314170546.af552b4e.sfr@canb.auug.org.au>
In-Reply-To: <20110313.225312.193696949.davem@davemloft.net>
References: <20110314152456.b49b2693.sfr@canb.auug.org.au>
	<1300078778.3962.22.camel@localhost>
	<20110314163135.f366742e.sfr@canb.auug.org.au>
	<20110313.225312.193696949.davem@davemloft.net>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Mar_2011_17_05_46_+1100_GWvTH5VqDpEmOrcY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Mar_2011_17_05_46_+1100_GWvTH5VqDpEmOrcY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sun, 13 Mar 2011 22:53:12 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 14 Mar 2011 16:31:35 +1100
>=20
> > Maybe some config option changed ...
>=20
> Perhaps GENERIC_HARDIRQS_NO_DEPRECATED?

Yep, that has been turned on for powerpc now.  I guess you will have the
same problem on sparc64 of you merge the net-next and sparc trees ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Mar_2011_17_05_46_+1100_GWvTH5VqDpEmOrcY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNfbA6AAoJEDMEi1NhKgbs3d0IAJcuIn0Ib4TsO6q7ez3upJrw
EHPJ9YBpMfZeC+qKM7ucyvyKQ/2uWgQxQN7LZ/IGV23S+NKQGaZMNY+Q5ww6bRUL
hvp/3tBME1qAe1cL3VD9+NVEjeRfXlIz7aEPlkIcm1ifuhN65+BSYSWxhwz6whDd
u5ZA7U1plS9mUdVckhIb/dZCP+b3Pcct+NI+TYAnrawHdvKl0N5qz782+uCm5FXs
nLMUrJiqjLJbTdqxq74arE8L3h/IQo+Oo2DktZyUHQiCh+iK2pw9QrRp/cRLmIHs
Aa3GA8iPcBrICXgYcTa7QTU6OWcvOIFda1gKHIlgCSUwwylMH2jkpb2NpTAd6kE=
=xHkm
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Mar_2011_17_05_46_+1100_GWvTH5VqDpEmOrcY--
