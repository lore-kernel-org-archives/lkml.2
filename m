Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1JXWXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:23:52 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:33266 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab1JXWXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:23:51 -0400
Message-ID: <4EA5E573.3080006@nod.at>
Date: Tue, 25 Oct 2011 00:23:47 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix kmalloc argument order in um/vdso/vma.c
References: <20111024221532.GA22671@redhat.com>
In-Reply-To: <20111024221532.GA22671@redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8F7FF46F5A77E692C0DD6A83"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8F7FF46F5A77E692C0DD6A83
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 25.10.2011 00:15, schrieb Dave Jones:
> kmalloc size is 1st arg, not second.
>=20
> Signed-off-by: Dave Jones <davej@redhat.com>

Applied, Thanks!

I'm a bit shocked that this obviously wrong code builds and seems to work=
=2E
How have you found this?

//richard


--------------enig8F7FF46F5A77E692C0DD6A83
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQEcBAEBAgAGBQJOpeV0AAoJEN9758yqZn9e62sIAIWE3m4ggm2TtJrcHhra6HCi
WBHOxLyfAg7JgfWp+IGnw/B6eQoM/n8j1K8FvKOcegdS+uAeKAVSvPp/diWxYnlO
cTqPdchcBPjieqcqXkksiasL3FGbrBLpoEqK8amSMaeL5AA6WmnCfJ6TibLw/QxW
cumq/EyISsLvuhBGd7/DzYiEZKQx5sTKyq3CrNgUEhVT92sIV0TGNX2Q+iXBEGjG
PdFC8EjQCmXfN5Q3MRCU9QSQud6SqjT8SBTRF94Q1A7cuB38q2s/Un+1fB/OYU7c
NPNnK0zlVFsJgC68ggYuqRZQMEf6Pop+Bzt/m43yakiZ4mDbIQUS0WBtmNklpoQ=
=8oPi
-----END PGP SIGNATURE-----

--------------enig8F7FF46F5A77E692C0DD6A83--
