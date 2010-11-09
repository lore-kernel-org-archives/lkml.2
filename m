Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab0KIEDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:03:01 -0500
Received: from ozlabs.org ([203.10.76.45]:53719 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab0KIEC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:02:59 -0500
Subject: Re: [PATCH] powerpc: Add jump label support
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@ozlabs.org,
        jbaron@redhat.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Anton Blanchard <anton@samba.org>,
        Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <1289274119.12418.79.camel@gandalf.stny.rr.com>
References: <45fbc3cd7f6ce404d1e25bf01695fb629d86189d.1289189560.git.michael@ellerman.id.au>
	 <20101109133517.b6be28bf.sfr@canb.auug.org.au>
	 <1289273608.21111.194.camel@concordia>
	 <1289274119.12418.79.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IkgJDMo06ESIiYhjjcHt"
Date: Tue, 09 Nov 2010 15:02:56 +1100
Message-ID: <1289275376.21111.227.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IkgJDMo06ESIiYhjjcHt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-11-08 at 22:41 -0500, Steven Rostedt wrote:
> On Tue, 2010-11-09 at 14:33 +1100, Michael Ellerman wrote:
>=20
> > > You don't need this protection in a file that is not exported to user
> > > space.
> >=20
> > Ah true. I'll respin after I've heard if anyone has tested it :)
>=20
> Don't wait for me. I'm stuck debugging some other crap. Getting a 4.5
> PPC compiler working is very low on my priority list, unfortunately. :-(

No worries, testing is for sissies anyway.

There are 4.5.0 crosses on kernel.org, I think they're the same as the
ones I'm using, which seem to work on powerpc at least.

http://kernel.org/pub/tools/crosstool/files/bin/x86_64/4.5.0/

cheers


--=-IkgJDMo06ESIiYhjjcHt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzYx/AACgkQdSjSd0sB4dIEkgCeL3KbuRYU2OJi8Jw4QVgootyF
gIQAnA1tyXLKJWYDzCo03E3gYEhZk+rd
=/Dt7
-----END PGP SIGNATURE-----

--=-IkgJDMo06ESIiYhjjcHt--

