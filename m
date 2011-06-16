Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1FPJh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:37:28 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:55799 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756068Ab1FPJh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:37:27 -0400
Date: Thu, 16 Jun 2011 12:37:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND/PATCH 0/2] trivial patches
Message-ID: <20110616093720.GL12230@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305589270-5389-1-git-send-email-balbi@ti.com>
 <20110615130724.GN471@legolas.emea.dhcp.ti.com>
 <alpine.LNX.2.00.1106161122570.22872@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHuqAdgBYNjQz/wy"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106161122570.22872@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lHuqAdgBYNjQz/wy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 16, 2011 at 11:23:54AM +0200, Jiri Kosina wrote:
> On Wed, 15 Jun 2011, Felipe Balbi wrote:
>=20
> > > following patches avoid double semicolons at the end
> > > of module_init/module_exit calls.
> > >=20
> > > Felipe Balbi (2):
> > >   trivial: add missing ; at the end of module_init/module_exit
> > >   init: drop trailing semicolon from module_init/module_exit
> >=20
> > ping... ACK ? NAK ?
>=20
> I got some conflicts/rejects when applying it right away, so it's now=20
> sitting in my queue with postponed low-priority patches.
>=20
> If you'd be able to rebase it on current Linus' tree, it'll help.

I'll do that. Will also check again for any missing ; at the end of
module_init/exit.

--=20
balbi

--lHuqAdgBYNjQz/wy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+c7QAAoJEAv8Txj19kN1tHwH/2X6ULC0Zh8DwVdZ+81Lv/tQ
evRdgYEYVBP3VTNFkSTOsj9h+MYrQinh7RZUueaL4xM83IKkTefsUysk+KMH1Wvn
z21Puqd0jN+BYtuoDESqcH5pWz25HktqACJRw3HvslZZ3GPgP+H3HR8u6xY/Fq1y
fYFPhk3Xx2LDuKlNUArPlOEYuzcXUAljIWuT0NLtuff8b4YcxHzkHYWHYP7RfiEy
+qoJ6I3Zb//DtxUPqFjw+oOWSIkZJrTS4SYX/pReK+BtustbYfCmucMOdu8bzCcq
uBl/acd0MWFVaTCSIhWiL/nk/ikuoY/6VHdxcfh6PRO9KSq6s7pXp+VERmkR1vM=
=Wbfc
-----END PGP SIGNATURE-----

--lHuqAdgBYNjQz/wy--
