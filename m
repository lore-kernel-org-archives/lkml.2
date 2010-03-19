Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0CSAg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:36:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50642 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0CSAgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:36:25 -0400
Date: Fri, 19 Mar 2010 01:36:22 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Ferenc Wagner <wferi@niif.hu>
Cc: dedekind1@gmail.com, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: CONFIG_MTD_DEBUG vs generic DEBUG support in kernel.h
Message-ID: <20100319003622.GB12348@pengutronix.de>
References: <878w9swhlv.fsf@tac.ki.iif.hu> <1268744759.20017.58.camel@localhost> <87vdctzjn4.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <87vdctzjn4.fsf@tac.ki.iif.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> something standard as dev_(v)dbg or pr_debug/devel (btw. what's the
> difference?) instead.

pr_devel will never produce code if !DEBUG. For pr_debug, it may be differe=
nt
as we have DYNAMIC_DEBUG meanwhile (see kernel.h)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuixwYACgkQD27XaX1/VRu8RwCeNoUG6JOT2m94FO7TzVz/sDDq
VHgAn0d4YWYUblMZUGdPUf/mkRmIYPuv
=msme
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
