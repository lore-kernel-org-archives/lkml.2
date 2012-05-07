Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2EGG4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 02:56:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:48454 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab2EGG4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 02:56:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="140846991"
Message-ID: <1336373967.2492.17.camel@sauron>
Subject: Re: [PATCH 8/8] kbuild: remove useless warning
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Date: Mon, 07 May 2012 09:59:27 +0300
In-Reply-To: <1336205926-13946-8-git-send-email-sam@ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
	 <1336205926-13946-8-git-send-email-sam@ravnborg.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZA0IPySya51Tl6QXELJu"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZA0IPySya51Tl6QXELJu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-05-05 at 10:18 +0200, Sam Ravnborg wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>=20
> This patch removes annoying warning:
>=20
> Makefile:708: "WARNING: Appending $KCFLAGS (-Wno-sign-compare) from comma=
nd line to kernel $CFLAGS"
>=20
> which is printed every time I use KCFLAFS. The commit which introduced th=
e
> warning:
>=20
> 69ee0b3 kbuild: do not pick up CFLAGS from the environment
>=20
> tells about the problems when people have CFLAGS in their environment,
> then switches to KCFLAFS which should be enough to solve the issue, but
> it anyway introduces a warning. I think it is too much and I find this
> warning very annoying - why should we warn users when they use the
> build system properly?
>=20
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Sam, thanks for taking care of this.

--=20
Best Regards,
Artem Bityutskiy

--=-ZA0IPySya51Tl6QXELJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPp3LPAAoJECmIfjd9wqK0H6gQALBXdZm5RX6hUads4gbCUmx2
6wyQ3RLhIdRBgy9AkW1lM2/gopzzi+5lcv0sG+qXaAVJW0trwN0w4syIu5BBvH0r
R1w+AJUqjH8bnhPceINlfhy7sXhVGABVb++9ElffwT2Sfn9M4AgCXi/TJr8RQBBp
Tv4oEdGsV7BrsuFIKiYvMSmLReIj5VCnecjhy0BE2oRlPmd5MUOkBc05gs6WYjM2
MM7oaZmqCOh1NI5eY8Ecv7ksG4XES4hEiOGCJSkTiH5b4jGyhgRl4CrNdu/37Ehx
/8F/wucT1iMbLZnuTdPKN4itxBO2VlZUsN1yFLzIihwrQOqbEgqDBWZRIq7mG5Il
Zw8cOpeCva2I1zpO4wUWw3t8BzVp4QZUinITxbK7jDlMlS0EQMhq4uzSfR8bE4lQ
LaAifdIT+qnH6yBOF5lEciecrmfuFpW3SrHVA2LlnJHSAyza1BPfBmgDZMYzPvj1
Rdad4SJGm8eU8nNAq5nqFcFojEnySQ6+jXkAfJ1DH3hhMx39nFihNs/csN8YBfAG
FH0Ro4u66KK6jW4kU+k4sh3CJmaoIjLA7GQRlxL+/o1T05vR8D0nhdFsMRhwjWiL
SA/q+X8yaXdkG6ngGatMRyLOSLaEaYHksM36LE2zRopuo1oz4gFOE9YtGKVAsSZJ
QFUe8LO/TCcI07Z6S58n
=VH2p
-----END PGP SIGNATURE-----

--=-ZA0IPySya51Tl6QXELJu--

