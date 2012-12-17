Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab2LQDe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 22:34:29 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34464 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2LQDe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 22:34:28 -0500
Date: Mon, 17 Dec 2012 14:34:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Thompson <set.mailinglist@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build warning after merge of the final tree
Message-Id: <20121217143415.252a2f60076d1ba03807df55@canb.auug.org.au>
In-Reply-To: <20121217142238.a0840563304419bb345ac25f@canb.auug.org.au>
References: <20121217142238.a0840563304419bb345ac25f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Dec_2012_14_34_15_+1100_Byx752Tfexmx3J6+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Dec_2012_14_34_15_+1100_Byx752Tfexmx3J6+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 17 Dec 2012 14:22:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (powerpc allnoconf=
ig)
> produced this warning:
>=20
> warning: (PPC) selects SPARSE_IRQ which has unmet direct dependencies (HA=
VE_GENERIC_HARDIRQS && (IRQ_DOMAIN && DEBUG_FS || MAY_HAVE_SPARSE_IRQ))
>=20
> I don't know what introduced that.

Actually probably caused by commit a1eaa3bc8247 ("Kconfig: fix Irq
Subsystem menu") from the akpm tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Dec_2012_14_34_15_+1100_Byx752Tfexmx3J6+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQzpK3AAoJEECxmPOUX5FEF7wP/1U3FzTfBB14A5qFbRWk/TyC
OgLEObXrGx6H0h2jLPTds76rgoapM6/UkmiTuN4szleml6FaL1C29FULeUVDlfhT
afGiKo6ndF+6rLiu45bU/FXKzkDUtCd4P1CR54hlXtEyyuzGATkLlHh7zQkHbUni
08ZXRl+Elucy4YQLtAuJjxTzLB9JEHOU3YaWxIBf59i0wVetb93frOX5mw40/C7U
cUsAIlTHE3iq7xH0g2W3UJ6pw0CfLdSkfQJfhJk8mDkaHfpvQkC7Jj0yiHWMT/aW
NFqmfRM2/YO/YCK3vQBaqKswE9RwswHTn2fQ9o8txRHp0dL5QVhvRdzzurVKk33K
ctXhBCeu1Nis+avWSsGjiVpQnmbkXkufg8TxsoMyEJ8Rv+oCQoaqXl7AItXK5OZy
w5f2EZGWwzHOTNsULW/uyoGiU8/UORz0tGu1l+yNNovI120jTPHIFh+gf4cVtNVi
9x9pBxH6y61AEv9sygkvJ/63OXDJSPlOsaTCCTfbSv5eqC8AjrQaZWYcji1E3ofv
rI+q3i9yobdUnsVoRn4Jg84SQjq46HSkF7wptntDVfTrOnV9Bk/HV/UFZ7aOTHMT
q8CdwfAkD7Q6iR3QVeM+XcZjjOIMU/A1zej6TjNV0JOdkI6RitKmdCpuInUz6phG
f50HwwXoss5al21BOmcO
=VeTh
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Dec_2012_14_34_15_+1100_Byx752Tfexmx3J6+--
