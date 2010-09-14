Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0INKR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 06:17:57 -0400
Received: from vps.mortis.eu ([79.99.135.181]:59710 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab0INKRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 06:17:53 -0400
Date: Tue, 14 Sep 2010 12:17:51 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Lin Ming <lin@ming.vg>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why not make LKML-Reference useful?
Message-ID: <20100914101751.GH29094@salidar.me.mortis.eu>
References: <AANLkTin9Ry6hCBciLkg2ExgERv9SHq5vO-Zvxy3Ei_JJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xjyYRNSh/RebjC6o"
Content-Disposition: inline
In-Reply-To: <AANLkTin9Ry6hCBciLkg2ExgERv9SHq5vO-Zvxy3Ei_JJ@mail.gmail.com>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xjyYRNSh/RebjC6o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 14, 2010 at 05:52:26PM +0800, Lin Ming wrote:
> What's LKML-Reference in the kernel git log?
> In my understanding, it's a link to the original discussion of the
> patch on LKML, for example
>=20
> LKML-Reference: http://marc.info/?l=3Dlinux-kernel&m=3D128445596126705&w=
=3D2
>=20
> But I never see such a link in the LKML-Reference of the git log.
>=20
> Those LKML-Reference are really useless.

No they're not, those are the Message-IDs of the referenced headers
which can be used to search archives with.

> Why not put a link in LKML-Reference?

Now, links OTOH *would* be useless on the long run as there's no single
entity maintaining LKML archives, so whatever entity you link to, you
become dependent on.  Having Message-IDs at least allows you to search
any available archive (provided it allows searching on Message-IDs).

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"Always code as if the guy who ends up maintaining your code will be a
 violent psychopath who knows where you live."
  -- Rick Osborne

--xjyYRNSh/RebjC6o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyPS88ACgkQZBYm/87l50IO6ACgroeIZuOFGVfmqbAMqW06zO2x
INoAoIsSKJV9oLdTXpQSW3i6rkQQWFBd
=8Lzx
-----END PGP SIGNATURE-----

--xjyYRNSh/RebjC6o--
