Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab1LMOvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:51:19 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:53173 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1LMOvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:51:17 -0500
Date: Wed, 14 Dec 2011 01:51:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, arnd@arndb.de, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 14/17] UAPI: Make linux/patchkey.h easier to parse
Message-Id: <20111214015107.340d6f5c9b7bb886ec51a840@canb.auug.org.au>
In-Reply-To: <12078.1323784677@redhat.com>
References: <11863.1323784204@redhat.com>
	<20111213235714.8e1c456786e60acc691b899e@canb.auug.org.au>
	<1323770653-19177-1-git-send-email-dhowells@redhat.com>
	<1323770653-19177-15-git-send-email-dhowells@redhat.com>
	<12078.1323784677@redhat.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Dec_2011_01_51_07_+1100_gyyjr_pCd7k9uJtp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Dec_2011_01_51_07_+1100_gyyjr_pCd7k9uJtp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, 13 Dec 2011 13:57:57 +0000 David Howells <dhowells@redhat.com> wrot=
e:
>
> Actually, it doesn't seem to be necessary.  The header splitter managed t=
o cope
> without it and did the right thing.  I think what happened was that the
> splitter didn't recognise the _LINUX_PATCHKEY_H_INDIRECT thing as a reinc=
lusion
> guard, so it just tossed that into the UAPI header, then recognised the
> _LINUX_PATCHKEY_H thing as the reinclusion guard and proceeded from there.
>=20
> Would you prefer that I remove that from the comments or would you prefer=
 that
> I leave things unchanged?

Well, the comments should really reflect the patch, right?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__14_Dec_2011_01_51_07_+1100_gyyjr_pCd7k9uJtp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO52ZbAAoJEECxmPOUX5FExEAP/2JDpoNEWo1Zl2ziNdLDljI2
UKyNMwBzzi2bQzSTLXI+x6vCTGUwFeUilTK76Nrkbfmvkq6W8Zufq9UOpnwTn2ZK
qgSKgyZv2pIf1/z4FFcK58JZNE2pFIZwqPoxVkjcRZmWQk0lR5wv2OvJMhoLGV4B
LHnVAVseIN7tRBDdPksBOGT+gxh+IXQ3TNYcVITlw4feW5xvRc/fkQrg8xdnlcF3
qH0ITl2hmIzkc0vKCLxDE1VRHOOAbsVxJUv0RJOTXkMujpiBjw1ER812dLde0aS4
WkDCl8Er2XOd0ViQNRFpXDKWwaFNKJn6Z93CIcOng/zWftcLYROhCGLyybgc5wea
dhAhs+bNCWNCMhw1lmMrD2kMl03jseYRub3XZT3ZanJPwiRt+40PuJVKx0cB/rNA
AMsOGDee7v91Pkcvtd44IWr60wOgJ46HXv7ps1DpuAcg8eNQ0Ti+V11/ly08SMHF
oPBXB//U8RQQfGg/wsnOc/XcxKFc/7PiuhUgftIeOHkoqV9HR+zGj6KQHGj8O45B
MKphPzaIMaJyXE8Cmb6N9KHsDskQMP3ipEJb/pv+oC3eL3woPyEHJaDBUjrXO6vt
jxcOnulzSH5ZE6RuS1zZkw9vu/MH+T1gQBi0tqe8WkPFDvklwDxty9LpM0ENPEGe
bLxSxDtEHVg1EPTQG8cn
=oZbY
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Dec_2011_01_51_07_+1100_gyyjr_pCd7k9uJtp--
