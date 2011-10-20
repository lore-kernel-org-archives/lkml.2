Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab1JTA2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 20:28:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665Ab1JTA2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 20:28:15 -0400
Date: Thu, 20 Oct 2011 11:28:11 +1100
From: NeilBrown <neilb@suse.de>
To: Dan McGee <dpmcgee@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/raid6: Fix filename emitted in generated code
Message-ID: <20111020112811.52c74ed0@notabene.brown>
In-Reply-To: <1318883348-29961-1-git-send-email-dpmcgee@gmail.com>
References: <1318883348-29961-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KgS0LzIKuBHFeNPiiPg5/qi"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KgS0LzIKuBHFeNPiiPg5/qi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Oct 2011 15:29:08 -0500 Dan McGee <dpmcgee@gmail.com> wrote:

> The files were renamed in commit cc4589ebf; fix the name in the file
> itself.
>=20
> Signed-off-by: Dan McGee <dpmcgee@gmail.com>
> ---
>  lib/raid6/int.uc |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/lib/raid6/int.uc b/lib/raid6/int.uc
> index d1e276a..5b50f8d 100644
> --- a/lib/raid6/int.uc
> +++ b/lib/raid6/int.uc
> @@ -11,7 +11,7 @@
>   * ---------------------------------------------------------------------=
-- */
> =20
>  /*
> - * raid6int$#.c
> + * int$#.c
>   *
>   * $#-way unrolled portable integer math RAID-6 instruction set
>   *

applied -thanks.

NeilBrown

--Sig_/KgS0LzIKuBHFeNPiiPg5/qi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTp9rGznsnt1WYoG5AQISYw//ZHiPDSvdisuR7Wc4+HJkro8050uhRMLq
psOc0wJHpcRMF6SyBX2KhGKqbtFP0asK0+QRBl+YpMlZ3HPanOW/GFRu3F+pQ7Qs
iywMY4V4uCCIRqRfem7iaSF8If3G8zzCADxIBy9H5iAoWOz8ddOFbqp8mam+KHqq
c92ZBqWuX6ge7ZikctNreEKthpl+rXcGMh6GLSFyC+pku8rpei9Mn1tf5vU25F3o
44gSWB/zGQerVh6BxkFVuKVe8hWp6U/XnAUcZJyZTQdtGlYnoY8/bvUe1qYnqKX6
RWch1cXk9MA7NByfaaybGK0U8sF+TltCRbQB9rVfHjIWv376vvl6Dkbd83yGnIyS
yhKkUdezWNFCrxy557zpZNhmxUrD7iacUg2M3pxcA4fv56rcZ/athTodCcnwIiB2
ruWgKrlLHE3jVbMMilnPrc2TYtMEEOp7iCh/m3f0DxRqos6SHM0Jw5kPrAPrYHvb
q0K3ReMksWc1w2TUfoN5BbPIPUAxqFDwpgvCwwWM1B/vNlAVRPsFQpH8RBMI2QC2
GmIgLvTzK51vjKZFNhwznclPtwbyqYsH0YPwCPA77BEeSDps8XhayJ4Zz6XnzW1P
NXuB7n0ERU8hJrofgkSGCUaHF6yaHQ02m4/jd0KSJB60lIDOuT6Y4eFShiWm+OSO
ul9m0Ai98IA=
=W7wc
-----END PGP SIGNATURE-----

--Sig_/KgS0LzIKuBHFeNPiiPg5/qi--
