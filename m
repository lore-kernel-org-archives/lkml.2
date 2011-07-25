Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1GYOAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:00:00 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:46294 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab1GYN76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:59:58 -0400
Date: Mon, 25 Jul 2011 16:59:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andrea Galbusera <gizero@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: power: bq20z75: problem with optional battery detect gpio feature
Message-ID: <20110725135953.GC18062@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <CAC+thW0Cx4pQDeZ2ZJfvFMfv23ExDmS5LDM8_-1Nz23t1TpJcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1AtvaQRkIQxkm1Oe"
Content-Disposition: inline
In-Reply-To: <CAC+thW0Cx4pQDeZ2ZJfvFMfv23ExDmS5LDM8_-1Nz23t1TpJcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1AtvaQRkIQxkm1Oe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 25, 2011 at 03:55:34PM +0200, Andrea Galbusera wrote:
> Is the in-object feature really optional?
> If battery_detect field in my bq20z75_platform_data structure is not
> explicitly set, I suspect the driver ends up requesting an irq for the
> GPIO number 0. This look indesirable.

set the gpio to -EINVAL. gpio 0 is a valid gpio number. Maybe we should
remap zero to 1, 1 to 2 and so forth... Grant ?

--=20
balbi

--1AtvaQRkIQxkm1Oe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLXbZAAoJEAv8Txj19kN1I4sIAKGW2MUKF1PT8KHRn3Dt9Aa5
3z8CrauUkKgk3r3DWfw7dakiwNOp340CezyJz3krRMK+y3faln+K5XW6qdHSmWgG
D39/9RZeDHhh5RrN/pbYv/U05QbzMFAThNsKZJlnF4+b+n+3b80ii6xSshCLAxYt
7wZder4KNZNNSl8Dk7rR0xj4utaNUpUaORFG+F1cyqLyxcpkiCu0oPujE9s2QI+r
Q3nvEJ8CFzbTNUA5N3VLptMPO5EzyK5SwY1sp/u+nfcQeugzTLqI9hQ7Nq8da8Il
yOq7Gmua1snenAEOHmyEpohY1pFs3PcPadrL+roc8MMvQBJN3fUzm8BCwMWyihw=
=8RgI
-----END PGP SIGNATURE-----

--1AtvaQRkIQxkm1Oe--
