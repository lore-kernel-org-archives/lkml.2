Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1BCC3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:29:55 -0500
Received: from quamquam.org ([88.198.196.3]:50982 "EHLO quamquam.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab1BCC3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:29:54 -0500
Message-ID: <4D4A1310.8040607@poelzi.org>
Date: Thu, 03 Feb 2011 03:29:36 +0100
From: Daniel Poelzleithner <poelzi@poelzi.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110124 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: lwn@lwn.net
X-Enigmail-Version: 1.1.2
OpenPGP: id=0A7B003D;
	url=http://files.poelzi.org/poelzi.asc
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0AC1FAEF81C982FC75FBD10D"
X-SA-Exim-Connect-IP: 91.64.160.209
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, lwn@lwn.net
X-SA-Exim-Mail-From: poelzi@poelzi.org
Subject: [ANN] ulatencyd 0.4.0
X-SA-Exim-Version: 4.2.1 (built Sat, 07 Nov 2009 20:03:47 +0000)
X-SA-Exim-Scanned: Yes (on quamquam.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0AC1FAEF81C982FC75FBD10D
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

I'm happy to announce ulatencyd 0.4.0.
This is a new major release towards prefect user experience on moderns
Linux Desktops.

What is it ?
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

ulatencyd is a scriptable daemon which constantly optimises the Linux
kernel for best user experience.
The default configuration tries to increase the responsiveness for a
typical desktop system and protects the system from malicious
processes/groups.
With a different configuration all other types of systems can be
adjusted as well.

Website: https://github.com/poelzi/ulatencyd/

=95 Latest Release:
  https://github.com/downloads/poelzi/ulatencyd/ulatencyd-0.4.0.tar.gz
=95 Package Repos:
  https://github.com/poelzi/ulatencyd/wiki

Major changes since 0.3.0
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=

  =95 DBUS interface to query and control ulatencyd
  =95 Much improved desktop config.
    It now uses the task group as primary grouping value
    Per group swappiness values
  =95 IO optimisation when available
  =95 Workarounds for GNOME & KDE which do not properly set task groups
  =95 More robust startup on missing system features
  =95 Tons of updates, improvements and bugfixes

kind regards
 Daniel Poelzleithner


--------------enig0AC1FAEF81C982FC75FBD10D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNShMWAAoJEFYpgV2Roepc+2kP/2q/XDpVGN92DMLx7ie5eOsp
3Ctzr/kCCTFAvFPWds/WCGUAx0U9rMlT/vk6+Atje2vNSkULyP8hJCQSggCkqGoh
vDumd7lugAQ/jj/i95igpMYt4kS4cHZHWIoMbq4HvBAH8e6xYNYQjy6FA10jnNh8
BCH9AN11QueOjn2RKHN/wB3EnT4W7IMOWcLa8tWpQZTnGw1DDIlU04iE4C2RayQb
6ogLqGM8mmXX2Ig1TSccLOJWTdSQpcYLG8MjBj4TAVEBC5YEkBWKakpF34i2iNot
OQ8Qzx24FVqFA1+1b0uE+nExn1OrlbBu9Fb9aDFFHQUu1wzRHlnnMJ4oJkDT9vnX
PdvsCvNejFpJA/EfOoIRSD7J3B9YHj/9f14i9V7d1KaaCw2jYJ6aMJG0Mv1Byjs/
78C157qE64NxmONw0742LrhPd103a68MURsdOafM8mwjhoKsElpnnhKLVScyt0RA
EHB8AMv/4sIXuPnizeFBuS89JJyOYSvnbXOUfjvLSimmgj004urghOZrDB45u66l
cuac6yDaBpVpp45lvlmkk4u+93Tj2JHV2Ww2QhAOeNvfnnVxShDy9fbBByy8qC18
UBv2nwQLkU2ngH79gbC61lYBRUPMg6jsgJP5bCcHdtVToUpQ4eftqLDe118Nklkz
Dw5m+YBXlAcrizzkuEUt
=VMGl
-----END PGP SIGNATURE-----

--------------enig0AC1FAEF81C982FC75FBD10D--
