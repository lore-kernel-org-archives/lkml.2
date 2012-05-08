Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2EHH3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:29:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:2456 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab2EHH3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:29:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="163286283"
Message-ID: <1336462376.23308.14.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] MTD: UBI: remove superfluous "!!" operation
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 10:32:56 +0300
In-Reply-To: <1336430840-27232-1-git-send-email-richard@nod.at>
References: <1336430840-27232-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-zMe0KfcHcnkq4QDZRaMZ"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zMe0KfcHcnkq4QDZRaMZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-08 at 00:47 +0200, Richard Weinberger wrote:
> !!(x < y) and (x < y) are identical expressions.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>

Thanks, pushed to l2-mtd.git.

Since you are submitting often, you may save me a bit of editing if you
prefix UBI patches with just "UBI:" :-) But I do not mind amending
patches if you don't.

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-zMe0KfcHcnkq4QDZRaMZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPqMwoAAoJECmIfjd9wqK0z7wP/0dgscQMbxnGwpDgoJxL1Uej
5dSEmH98PnxHzyfrVUORpah1WBN1I7HEJjWFvjtwmGmuSEmu1R+hsif8+MhsE9q2
bcSVadUArW0tm/lhL53rDaa1O/KDIUoA7DU5vurn6fSN2qCSvAjayuDwi0X0I76G
YcCp5KC7q/+NRqnlfbj79qw3g32J95tE6qArntfn/flMdV7BWVhAWT7u0PpN2GHN
mDO4sjgWv4lyuiEpcVgCIDsTmmrYSViQOwO6ZtV8agJDjlfXMFdglVMvhismQ0XB
wAsxXJ7FxBNJAy9FEJor7MMi3B2K+ZMvksSQiEjS+YDoNkhIZq6ahypPlxVuvqUm
oeF1Cc9WYai7zuh8YMuKCLgICUNEkSGnS2Uu4PsCZXl7PnyNcU9sHFEXppuSUYz1
dTwKWPvbHUg/vQDY6CkJbAKMKz9Wa8gdk2pe8q5EXBIFDeRbloE75Ko5HpBzIWns
VDH6Ti5Cbm88+NbJm03hl7fCJTVQmHcVEZKMveRWb8g0zbc6gPAIK0UqymzTzoc0
oI8+3QiJhCNBE0sNkRxHLHAi2paMnzlGsgRwUY0+uDpIIqB8Q2AiWzBvXQqywQUr
tSCuwkMXD7wFZO7v/YfCvmHo8bB4FCBKLLyAP+B2bQ4cmXjuyEEi3sCKZH0A/o7O
6vBlxqlb69E6ngjzjQY9
=IlsU
-----END PGP SIGNATURE-----

--=-zMe0KfcHcnkq4QDZRaMZ--

