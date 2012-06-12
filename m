Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2FLJtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:49:17 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:53731 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738Ab2FLJtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:49:16 -0400
Date: Tue, 12 Jun 2012 12:47:17 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Hemminger <shemminger@vyatta.com>, trivial@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: treewide: remove extra semicolon added by
 module_init/exit
Message-ID: <20120612094716.GJ9770@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1338990069-6627-1-git-send-email-balbi@ti.com>
 <20120606083119.0d0a0029@nehalam.linuxnetplumber.net>
 <87zk8bhfds.fsf@rustcorp.com.au>
 <20120611142028.380c5a61@nehalam.linuxnetplumber.net>
 <87zk89nznn.fsf@rustcorp.com.au>
 <20120612094349.GI9770@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MMMIZFJzhAsRj/+"
Content-Disposition: inline
In-Reply-To: <20120612094349.GI9770@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MMMIZFJzhAsRj/+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 12, 2012 at 12:43:50PM +0300, Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Jun 12, 2012 at 09:56:36AM +0930, Rusty Russell wrote:
> > On Mon, 11 Jun 2012 14:20:28 -0700, Stephen Hemminger <shemminger@vyatt=
a.com> wrote:
> > > Given common kernel practice and the fact that only 16% of the uses of
> > > module_init/exit are without semicolon and that other kernel macros d=
on't
> > > include semicolon.
> > >=20
> > > I recommend going with the majority and common practice...
> > >   1. Fix the 636 places that use module_init()/exit without semicolon=
 to include semicolon
> > >   2. Remove semicolon from module_init()/exit()
> >=20
> > Um, yes.  He should do exactly what he did.
> >=20
> > It's a wart, let's fix it.
> >=20
> > Thanks,
> > Rusty.
> > PS. CC's chopped; somewhere in there is a bad address...
>=20
> let me know if you need me to update the patch.

BTW, I sent a v2 of this patch [1] and that should be used instead. It
contains a fix to the sed script so that it matches also
module_init/exit when it contains a trailing whitespace at the end.

[1] http://marc.info/?l=3Dlinux-kernel&m=3D133899476223535

--=20
balbi

--3MMMIZFJzhAsRj/+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1xAkAAoJEIaOsuA1yqREOW0P/jynXrnQLzqOJeJ1GZ5nd9S3
WEMpvuHVxF5nMOKdh1XFvWPbpRSF3uJDBfLcdtrym2WT7rgyIlFo6TY09vk34Nvg
ZmXaK9H+ZggWZcNGQ2vpvOAT1JrNrzXnHIIkvDWmCbmW5veSQDPuJds3O+oJuhqJ
CVQkeoabYNDwWuDLYjsE62oP11BdbHBaPklHz5lU5OxeXNTPQ1xLi0SUBcbD+Usq
knakHQK3tivaI/qgiJt1SGtJOUwVlLr1mhMPzp9GIr+8L4KXzV/BFKnfIS97aVza
yJch51MagGKt/P2XiZceXg9qhi/+wpRlkrzd7sfddt94t1Pr20fjCr27lt1r/sPd
7Wj4M69+zoidMfJgohHu+mvj7Y6ATQJjUVG6DaAO/Ye08UtIpyf8CVQ9tOa3js35
E5SFvw55VlM843hd53Etp0xUCZwDlFtHRraxLxshquiGU7x30Gu8CvrqhoDauRCl
0XauRv3Vbl3IN27ly+13NV7Z07TlC/tzr7T+ARaTBUHj9VYEGRsvQm/DuU4EijXs
Ay8J4IcEfTmW8uBiLxmB4sQgjn06MKoAPckO4S4BUq0LAIcXpemg2K1VKJogb3R3
T/OTjPtC25voCBO9Cxh9A6WIfZ33eKrVojtdO4LKv0bjv6iuy7ECKnWVHVkH9y//
eKFgckepJqlPApQR2cvz
=z4Hk
-----END PGP SIGNATURE-----

--3MMMIZFJzhAsRj/+--
