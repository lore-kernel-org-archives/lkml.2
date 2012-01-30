Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2A3T2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:28:11 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:29951 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2A3T2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:28:08 -0500
Date: Mon, 30 Jan 2012 22:29:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Cc: =?iso-8859-1?Q?V=EDctor_Manuel_J=E1quez?= Leal 
	<vjaquez@igalia.com>,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>,
        Armando Uribe <x0095078@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/5] staging: tidspbridge: Lindent to drv_interface.c
Message-ID: <20120130192907.GX3294@mwanda>
References: <cover.1327348286.git.vjaquez@igalia.com>
 <7103a353d393f9b8366b141a608a4370e4392c7b.1327348286.git.vjaquez@igalia.com>
 <CAB-zwWjKfakESHw4Cw8JvJ6WpELz51E_9zVtjR0bF84yhMRfMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e9ndEBTQFD7P4kUb"
Content-Disposition: inline
In-Reply-To: <CAB-zwWjKfakESHw4Cw8JvJ6WpELz51E_9zVtjR0bF84yhMRfMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F26EF2B.003E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e9ndEBTQFD7P4kUb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2012 at 11:25:34AM -0600, Ramirez Luna, Omar wrote:
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_info("%s:%d handle(s) =
still opened\n", __func__,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_re=
ad(&bridge_cref));
>=20
> I remember the rule was to break lines as far to the right as
> possible, no? Chapter 2 CodingStyle, same for the other similar
> changes.
>=20

It doesn't mean you have to right justify things, it just means
indented.  The original code is fine here and the new code is fine
here.  It's up to whoever writes the code to decide.

regards,
dan carpenter


--e9ndEBTQFD7P4kUb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJu+CAAoJEOnZkXI/YHqR5LYQAJyCPeZ2kLFYvml31QBrVViB
ah2QgMNa7UlP7W4zHMB8QPDY17NcUWBmHvqK3fMoJg7q1nVp8EM0fU1C1bdThxmB
66LpAM8f8RxynLA6RU8AjbOVrdd8LSGXuZyo/+WxrC6wyW35b5TPNeZVBK7w386D
LlfNwLhCVsj+Dy3YZXMOWFGU18AE7f/0l1NDemtK9+PQ/q6iqHGeCiLAeqTddo5v
cwdrTOaB3GrNJI+msXEs7S2ILT8fyjH75ftEfWjKZK2PSnuoVninsiQdgcAI+lue
vTJYbBou3Apx0nuTt+vLomlw1uJ8m53L+oCP11pgfEtzmGdLDv3Ga7IFKbBurPvA
pcTRKrmbgZ7mNUgZ64Vb3LIZiVyJJ43gSlvaCZj3ZNYCzZaII11lg4JjgffZcOF0
sjqMrHB4pxSxS4poExODG947HeeQ4ZTL/H8nPpz2ep/Zo+oL/5uoIpQY6XmWb1no
8X1aocwCpNdSh3CzNSj9zrEuM7GvvdH8/eESNaU9Shdrs563I+8y/YRpuoNdpZhD
oGAcRHSoqo2apwe08N0Bq9eMV5J6N6Ecr829+MVuzE6a5rH2/Ijpgn+kHPaQp5yp
LnHZjhcBIKOgLwR5fZpz5wLV3YeCH32+YtmeSdwHeF9WNEhhWHmu4sJc/jg2EcZc
xK+6UmZGeqYmi46Ysish
=3wPS
-----END PGP SIGNATURE-----

--e9ndEBTQFD7P4kUb--
