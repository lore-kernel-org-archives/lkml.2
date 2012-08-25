Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2HYLKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 07:10:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59799 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2HYLKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 07:10:22 -0400
Message-ID: <1345893017.1815.2.camel@kyv>
Subject: Re: [PATCH 13/14] drivers/mtd/ubi/build.c: fix error return code
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 25 Aug 2012 14:10:17 +0300
In-Reply-To: <1345365870-29831-14-git-send-email-Julia.Lawall@lip6.fr>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1345365870-29831-14-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-GC/AR0VLVxtZ2NnzK35z"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GC/AR0VLVxtZ2NnzK35z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-08-19 at 10:44 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Initialize return variable before exiting on an error path.

Pushed to linux-ubi.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-GC/AR0VLVxtZ2NnzK35z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQOLKZAAoJECmIfjd9wqK0FlcQAL45bf4GsfJZHB8dOneVIEzC
jJS5Ck2X0YmijXq7oH14hcpHMPC/uQz/5xYoq+CxIj1z5HA3CcVC1xZmyeKvQfmJ
gvmD4e4MjbDpjKfB9SDCVXKar3hq5BWjCVpBChqX8yo+qzFyvWAWchA6F6KRcKlY
X6QHKffosiMQuMKebJvxbJG0z7MeNxgIhs1dA27Al84K0ZpwhjaDBC9UBiC4jeUN
dmqJMvNuN2yn/jCc5V7iwDBpacd00OIx/jPQ/i0viYEmcuIo+ePYWTPi0LDvBjnR
R80XICnXUJKq4Cs1ge/IjSKZ8pFzimI5WEnhfi1f6gMPKzmE+gcid+DXNTbOIyH0
AaP7qiH5sbeEOgPK8c6PsSrl4K8ZwVmGqVAsZXMIHt5Z66x4zCCz5YDT8267VNoV
QqfNrkRID7fn0CymeoEMwqhn6/VXO1iCAYA0WlCtTWhB2NQkvMTRJk8hPEga23DP
EnF8zHYuplTUf2ysIoIKCe+dYCMBRhTkglHsPeUmGsFf3YVAELFSdgcP24lxE+wd
Stdu3lEQGhGqyJDvlIPgQux/NEyqEtWnLgOMHQ62XwSjkHbSgusRNzW9GT+v0aGd
25eumBNQsPmrmBpg8vCawr0lOSdzWh8DIfI8EQfmbVi7UU6HjWP0ckVoxLdeRBeU
Pg6Ln7Vs1TKhqU2sn6nd
=D5+c
-----END PGP SIGNATURE-----

--=-GC/AR0VLVxtZ2NnzK35z--

