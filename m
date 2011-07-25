Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1GYOhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:37:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36416 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1GYOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:37:06 -0400
Date: Mon, 25 Jul 2011 10:36:55 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Fix ppc64 SEGV in dso__load_sym with debuginfo
 files
Message-ID: <20110725143655.GA4177@mgebm.net>
References: <20110725142209.66d540fd@kryten>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20110725142209.66d540fd@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jul 2011, Anton Blanchard wrote:

>=20
> 64bit PowerPC debuginfo files have an empty function descriptor
> section. I hit a SEGV when perf tried to use this section for
> symbol resolution.
>=20
> To fix this we need to check the section is valid and we can
> do this by checking for type SHT_PROGBITS.
>=20
> Signed-off-by: Anton Blanchard <anton@samba.org>
> Cc: <stable@kernel.org>

Acked-by: Eric B Munson <emunson@mgebm.net>

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLX+HAAoJEH65iIruGRnNejAH/jkkdWLkEi7KRfTXKtdbbT2C
PhuOO61eiF7IwETRQruBlgeushKp51nHCFRtesgVRmySzENXm3rf+4q6v+0UIc8B
x3RFI2wmacVkscjFI1Eb5zB+GyAw6MKLrJtachJy9kzuI89UgJ5P2e0UZrfNdFJK
pBlwD4tU3ETmx/61HEZhpnhiA/kMWNyYwMEjzrPtw9E/H7RCXrWNnvf+lKqJJqdr
u6tV1QbPn7GOVlELf19H6KMZTJ4l3sjYqnTlnKa+2jze8mEWtB4eIR377cloB6mn
tL8pL3F4PN66Oj4ODO2cti3T3Zcx8LVmIO2HubJx9YEZ7urnxngZNqcTcY/T3uU=
=nEca
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
