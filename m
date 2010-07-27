Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab0G0H2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 03:28:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48891 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab0G0H2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 03:28:33 -0400
Date: Tue, 27 Jul 2010 17:28:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: linux-next: Tree for July 27
Message-Id: <20100727172824.109929c0.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTi=ki084ymBzsnbgnFw952BSnSDzUyL+YH-4353b@mail.gmail.com>
References: <20100727160708.722c39c1.sfr@canb.auug.org.au>
	<AANLkTi=ki084ymBzsnbgnFw952BSnSDzUyL+YH-4353b@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Jul_2010_17_28_24_+1000_+pbqLt7W1yQz+5rV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Jul_2010_17_28_24_+1000_+pbqLt7W1yQz+5rV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jaswinder,

On Tue, 27 Jul 2010 12:54:22 +0530 Jaswinder Singh Rajput <jaswinderlinux@g=
mail.com> wrote:
>
> I am getting following compilation warnings in linux-next 20100727:

Thanks for the report.  All these have been previously reported and most
have patches (that are not in linux-next yet).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Jul_2010_17_28_24_+1000_+pbqLt7W1yQz+5rV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMToqYAAoJEDMEi1NhKgbsYZEH/277Kh5XGBNC9wnTLmPh8ZZs
R9dUj7qtSbmG3W6H5m/qf6gmQiBdAaLt25aT7hb86sifzck6IBLADgt1H5UbJtoC
PeHmJlfY0v4Sb5/kEId6Mf1Lxe+8V5v8db6N7xG6QodCqyd2mpIxZqZpqAkdmj5O
YrrlE5kIzKpeOtPJcpkeFiMeTmQx1e+CSqMEM23dI4xOhqcykDN0NKFk6swOcPpm
HIy8BS4Ru/7PyyMJ3mTr3M1UBjpKZvO1Qe+HGSdifVNlfHquTg02/i+aStLc7jWG
etQDj9H8+WIIusoGA/w9+T05kdnPesoWRGZY6v9fsv8m7H+xS9QPrUcQNzYOmO4=
=O+6X
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Jul_2010_17_28_24_+1000_+pbqLt7W1yQz+5rV--
