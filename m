Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab0KIDdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:33:06 -0500
Received: from ozlabs.org ([203.10.76.45]:44233 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab0KIDdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:33:01 -0500
Subject: Re: [PATCH] powerpc: Add jump label support
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linuxppc-dev@ozlabs.org, Kumar Gala <kumar.gala@freescale.com>,
        "David S.Miller" <davem@davemloft.net>, jbaron@redhat.com,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>
In-Reply-To: <1289225915.12418.2.camel@gandalf.stny.rr.com>
References: <45fbc3cd7f6ce404d1e25bf01695fb629d86189d.1289189560.git.michael@ellerman.id.au>
	 <1289225915.12418.2.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-w3D+0pu8VLtSMSPL4b+4"
Date: Tue, 09 Nov 2010 14:33:00 +1100
Message-ID: <1289273580.21111.193.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w3D+0pu8VLtSMSPL4b+4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-11-08 at 09:18 -0500, Steven Rostedt wrote:
> On Mon, 2010-11-08 at 15:12 +1100, Michael Ellerman wrote:
> > This patch adds support for the new "jump label" feature.
>=20
> Darn it! I wanted to port this!!!
>=20
> ;-)

Sorry! I've been locked in a dark room for ages and this was a nice
chance to work on some upstream code for a change :)

> > Built for 64 & 32 bit, tested on 64 bit. Survives a kernel build under
> > perf with all tracepoints enabled, and manual inspection of the patched
> > code looks right. But still, lightly tested, YMMV.
> >=20
> > Unlike x86 and sparc we just merrily patch the code with no locks etc,
> > as far as I know this is safe, but I'm not really sure what the x86/spa=
rc
> > code is protecting against so maybe it's not.
>=20
> Thanks, I'll give it a test on my electra as soon as I get a gcc 4.5.1
> cross compiler working.

Thanks.

cheers



--=-w3D+0pu8VLtSMSPL4b+4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzYwOwACgkQdSjSd0sB4dIvgQCgpN+7/z9m/ALqbxEBCzJjwx0h
Cx8AmgKd1c5SmvuY8GraTVP9KUxAdrMf
=a/t3
-----END PGP SIGNATURE-----

--=-w3D+0pu8VLtSMSPL4b+4--

