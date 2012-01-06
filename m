Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab2AFASx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 19:18:53 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932617Ab2AFASw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 19:18:52 -0500
Message-ID: <4F063DE7.2080405@nod.at>
Date: Fri, 06 Jan 2012 01:18:47 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: daniel.lezcano@free.fr,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: namespaces: Out-of-bounds array access
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA25311C4A4004CC47A7FB396"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA25311C4A4004CC47A7FB396
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi!

While searching a completely different bug I've found this problem:
If CONFIG_NET_NS, CONFIG_UTS_NS and CONFIG_IPC_NS are disabled, ns_entrie=
s[]
becomes empty and things like ns_entries[ARRAY_SIZE(ns_entries) - 1] will=
 explode.

Thanks,
//richard





--------------enigA25311C4A4004CC47A7FB396
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPBj3nAAoJEN9758yqZn9e52IH/in1mdQFv6/BujSBi1O747e7
XRfOwFZuYAQKoaUoQ5wJbFFCNvFHYG7KH8nswIRHPVevIZyCkyXQIm7CNu94300f
n05R+P1BOkz5Xai/6Vocz7cRLtDtEOa3forFxeOxo5dvPRyMKJOIpIpARaiOVpEn
lw+/hHu1IzWy52Xl1w2f6UPCHZttIHBar0q0R1YoRnrVK5k5Fyde9ffDmUyC3Enc
/6yY/A2+/BLfNzGqjC3FgX/SSOyToLa5OwfXZr0t/P2QdXVlgj05K7JE2E62fu74
gDGm155HaiwPP7zPi+4uRKv/6CKy8fuh4ZzySAcptNS6GJkT34/m+6wX0YzS0dU=
=NvPo
-----END PGP SIGNATURE-----

--------------enigA25311C4A4004CC47A7FB396--
