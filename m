Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2C3XvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:51:13 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab2C3XvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 19:51:08 -0400
Message-ID: <4F7646DC.8090802@nod.at>
Date: Sat, 31 Mar 2012 01:50:52 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Phillip Lougher <plougher@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Eugene Teo <eteo@redhat.com>,
        Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] sysctl: fix restrict write access to dmesg_restrict
References: <20120330234317.GC411@lenovo-rd230-04.lab.bos.redhat.com>
In-Reply-To: <20120330234317.GC411@lenovo-rd230-04.lab.bos.redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDBBF6865E0044E09D25B1AB5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDBBF6865E0044E09D25B1AB5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 31.03.2012 01:43, schrieb Phillip Lougher:
> Commit bfdc0b4 adds code to restrict access to dmesg_restrict,
> however, it incorrectly alters kptr_restrict rather than
> dmesg_restrict.
>=20
> The original patch from Richard Weinberger
> (https://lkml.org/lkml/2011/3/14/362) alters dmesg_restrict as
> expected, and so the patch seems to have been misapplied.
>=20

Hmm, indeed.
Any idea how this could happen, Andrew?

Thanks,
//richard


--------------enigDBBF6865E0044E09D25B1AB5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPdkbjAAoJEN9758yqZn9ezX0IAJz0XUMJOJqt3nE704iwkBqD
4WJeDik9qoeoU1mKMYt+Mv6jiA3z6Mf8g6hUs9TZwTU2/ezMB+SB6aDntW64vQg8
JRSLYs9qf0TUKJ8kAba4gElM5Gz82sk+/6kc1QpTgGxSimudPmpGv22uZ5taypMg
fbq+MuBzJrnlZrFEoCUL3erp5ogiGoEQrd3MT4gMGzgx1OkTD+1Uyz3FHbLA+c8D
cP/QcVgJw+nx0n5VX0U5MAMesgRobQ7Fh2RcEjYNJ8bvA67Z2QwdM8DqNTnPHrIF
qxDvwvd71Q2z+TGhtZ+k5mhZjiyGbDJLVkseQHmZFfCfxV4w4YwJlBfpZHGZCvc=
=Ch/Q
-----END PGP SIGNATURE-----

--------------enigDBBF6865E0044E09D25B1AB5--
