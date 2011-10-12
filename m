Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1JLWUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 18:20:42 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:36168 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751939Ab1JLWUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 18:20:41 -0400
Date: Wed, 12 Oct 2011 18:20:39 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Subject: Re: Oprofile Regression Caused by commit
 e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25 on PPC
Message-ID: <20111012222039.GC6158@mgebm.net>
References: <20111007204247.GA5444@mgebm.net>
 <20111010233842.GC24583@mgebm.net>
 <1318319095.14400.54.camel@laptop>
 <20111012165154.GB6158@mgebm.net>
 <CABPqkBRHkiOYEW+5Yo9p43c_2Dy+aAdJRXj3tah5J1QsV4AXrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <CABPqkBRHkiOYEW+5Yo9p43c_2Dy+aAdJRXj3tah5J1QsV4AXrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Oct 2011, Stephane Eranian wrote:

> Could be:
>    a8d757e perf events: Fix slow and broken cgroup context switch code
>=20

Thanks for the pointer, I will have a look at that.

Eric

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOlhK3AAoJEKhG9nGc1bpJfb4P/2CMX52WAiCza5aIN4da/Ry7
QEiX6Ff2Z66N3Zn4Llo4FXcdN2qJJfjIo4A35WCP5wNEs0t8gjFQlET6Yy8YCtVN
cihwSc/aYHF1hrRKdJfwQj6v9hO0lSy7NxcmrRrtaDY5ClM7xl5+1dnwkVKWoE2Y
zwkqmiYcfqW7uPvHjQdfylpDQDMhNWJ10iuQfiCRoo3RrS7CnhG8SxDD2SKHun5C
OaeJEUgUhcAFwVzcE5ju2Y7mXlkIZ9U46hjxeeSyDVL3L0KjLrr+QHPvxwlcbN45
BECIf5dF1HvPyWkCDhctSUQNxM88yf8tDtgWGRF8AJvjUCk1zv3QJ/GXJsQy6Yht
4VJatKLzUr1Y3h93+O1fKgTB7O4opqD0RrvguMbS5EOzG6tgoMjm7/faS4qxZSIv
QlnOyN1h/PCLi/LqVhgsv9slIlaMHpLKCtrWRiVbui5f7qSbpktedGeoLju3cAA0
yGLZWwcbqbX5+UH7+j5mg62DuVmvk9jdqITvf4vQTcAdyyzv3SstiFqKL/EKDYKO
FBkqBWGWcn6wZFPBUg3aRQp0jJHn0PIrGWyoI8yzbvj+rvPYRGNEPvUQTfrkaZOH
MtUTFm6gekjkcAqaGJ696rz3ZELN8mL5pVwHeOhjTLUcmC9RuU7CxXn+dARtJoY+
cwaDxZIqksg7AKE/aKnY
=9jki
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--
