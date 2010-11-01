Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab0KALCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 07:02:17 -0400
Received: from ozlabs.org ([203.10.76.45]:35219 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab0KALCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 07:02:16 -0400
Subject: Re: [PATCH 04/39] arch/powerpc: Update WARN uses
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <c6c46b5924e1cc9720d3ad76e6c11e982bd661e5.1288471898.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
	 <c6c46b5924e1cc9720d3ad76e6c11e982bd661e5.1288471898.git.joe@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4TyIFmVimvKgZvEMEDAo"
Date: Mon, 01 Nov 2010 22:02:14 +1100
Message-ID: <1288609334.10671.4.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4TyIFmVimvKgZvEMEDAo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-10-30 at 14:08 -0700, Joe Perches wrote:
> Coalesce long formats.
> Align arguments.
> Add missing newlines.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/powerpc/kernel/hw_breakpoint.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw=
_breakpoint.c
> index 5ecd040..d7343a7 100644
> --- a/arch/powerpc/kernel/hw_breakpoint.c
> +++ b/arch/powerpc/kernel/hw_breakpoint.c
> @@ -270,8 +270,8 @@ int __kprobes hw_breakpoint_handler(struct die_args *=
args)
>  	 * message to let the user know about it.
>  	 */
>  	if (!stepped) {
> -		WARN(1, "Unable to handle hardware breakpoint. Breakpoint at "
> -			"0x%lx will be disabled.", info->address);
> +		WARN(1, "Unable to handle hardware breakpoint. Breakpoint at 0x%lx wil=
l be disabled.\n",
> +		     info->address);

That appears to have done nothing other than turn a short line into one
that is now > 80 columns. Is that the latest fad?

cheers


--=-4TyIFmVimvKgZvEMEDAo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzOnjIACgkQdSjSd0sB4dKulgCdHKE+hDkBjgvP2mZLkdZOVnaR
RjoAmgNIdZErUBbPyMid+YEJKwOBXc+P
=fQET
-----END PGP SIGNATURE-----

--=-4TyIFmVimvKgZvEMEDAo--

