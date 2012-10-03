Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2JCWyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:54:02 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32862 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2JCWyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:54:00 -0400
Date: Thu, 4 Oct 2012 08:53:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-Id: <20121004085345.daf125b4f0e29179f999107f@canb.auug.org.au>
In-Reply-To: <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
References: <4FE9169D.5020300@redhat.com>
	<20121002100319.59146693@redhat.com>
	<CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
	<20121002221239.GA30990@kroah.com>
	<20121002222333.GA32207@kroah.com>
	<CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
	<506C562E.5090909@redhat.com>
	<CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
	<20121003170907.GA23473@ZenIV.linux.org.uk>
	<CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
	<20121003195059.GA13541@kroah.com>
	<CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_08_53_45_+1000_Kdwsv0b+MA2NHVOJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_08_53_45_+1000_Kdwsv0b+MA2NHVOJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Wed, 3 Oct 2012 13:39:23 -0700 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> Ok, I wish this had been getting more testing in Linux-next or
> something

If you ever want a patch tested for a few days, just send it to me and I
will put it in my "fixes" tree which is merged into linux-next
immediately on top of your tree.  If nothing else, that will give it wide
build testing (see http://kisskb.ellerman.id.au/linux-next).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Oct_2012_08_53_45_+1000_Kdwsv0b+MA2NHVOJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbMH5AAoJEECxmPOUX5FEdeMQAKM+wwysU+FkMNWi8Pa4zzm6
pqRFM8iMx0GodJvuNgh2ZwaVwOAGsnfwbOyetZLwAjsithMogU2YRbimTJjXmXff
1HCBIGvME/5hitVxQKWYDkQbPNxz8uduFVTRv84xgrSBCF2tt0RnlzaJn5oVVWFR
AVEmLVZIoeZ3tj5knPXmgvHUFfLad0abop8Hdm4e4kc76ThSSM/TGh5ye5RKSuSy
wMjs3nhxjliGTjkF2y1tkJ90m0MHn4VHHh4wfedS1V/qGJdte1hNkJ6eJy2W6lQQ
zrOhAWkKLMJ7CpCAbjKSZSX9Zj0z1ZjBScYHWmm/8YXYYAqx5XhmkoiHVsFkVFqd
8Yjep6C/nXz+vo1SKZyuywLDI0AXxj9IN5QxT6+xs+9XTJH1trx7/tTlNVyuf+pX
/n5USD1reVGIXjvhFyk6oXD4fZN9Hwxzds06i1LJ4aOpNBpqoW8O1UbJjfmRjsHa
71xqkA6b9ukPQqyQKlc84jhS+2of6G4II3Aqvqcfr4rtvuEjBhUrzEdH4ZL9yYP/
NQEakKaIV1mkO1y0zEd6Y49uXDq0DzGiQqG8xGmyfEATAlvU6lGVaYjIp4XH0Tc7
wOl0sZZ6iQryVEgUpu3V0M2tOlVAZAzBX/mzukKO66mtQKaj/SK/+W/UAaM0/KsI
wbZH7ghzCAPQL4lY47NO
=85pQ
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_08_53_45_+1000_Kdwsv0b+MA2NHVOJ--
