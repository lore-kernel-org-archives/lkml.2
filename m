Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab0KIDda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:33:30 -0500
Received: from ozlabs.org ([203.10.76.45]:44899 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab0KIDd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:33:29 -0500
Subject: Re: [PATCH] powerpc: Add jump label support
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linuxppc-dev@ozlabs.org, jbaron@redhat.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, "David S. Miller" <davem@davemloft.net>,
        Anton Blanchard <anton@samba.org>,
        Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <20101109133517.b6be28bf.sfr@canb.auug.org.au>
References: <45fbc3cd7f6ce404d1e25bf01695fb629d86189d.1289189560.git.michael@ellerman.id.au>
	 <20101109133517.b6be28bf.sfr@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-m72QxIJuGlTCCfsNO8KH"
Date: Tue, 09 Nov 2010 14:33:28 +1100
Message-ID: <1289273608.21111.194.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-m72QxIJuGlTCCfsNO8KH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-11-09 at 13:35 +1100, Stephen Rothwell wrote:
> Hi Michael,
>=20
> Just a trivial note ...
>=20
> On Mon,  8 Nov 2010 15:12:46 +1100 (EST) Michael Ellerman <michael@ellerm=
an.id.au> wrote:
> >
> > diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/inclu=
de/asm/jump_label.h
> > new file mode 100644
> > index 0000000..feffb86
> > --- /dev/null
> > +++ b/arch/powerpc/include/asm/jump_label.h
> > @@ -0,0 +1,46 @@
> > +#ifndef _ASM_POWERPC_JUMP_LABEL_H
> > +#define _ASM_POWERPC_JUMP_LABEL_H
> > +
> > +/*
> > + * Copyright 2010 Michael Ellerman, IBM Corp.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version
> > + * 2 of the License, or (at your option) any later version.
> > + */
> > +
> > +#ifdef __KERNEL__
>=20
> You don't need this protection in a file that is not exported to user
> space.

Ah true. I'll respin after I've heard if anyone has tested it :)

cheers



--=-m72QxIJuGlTCCfsNO8KH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzYwQgACgkQdSjSd0sB4dImUgCfR+Bv1i04RnNUAgrm9uq20Rfe
PqwAnjKZmg1Jmp8CwKDncsxXrA1JnRfD
=Qgeu
-----END PGP SIGNATURE-----

--=-m72QxIJuGlTCCfsNO8KH--

