Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2KROFQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:05:16 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41252 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2KROFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:05:11 -0500
Message-ID: <1353247498.1592.2.camel@kyv>
Subject: Re: [PATCH] mtd: de-select the chip when it is not used
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 18 Nov 2012 16:04:58 +0200
In-Reply-To: <1352449425-16496-1-git-send-email-b32955@freescale.com>
References: <1352449425-16496-1-git-send-email-b32955@freescale.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-WKnhYIhCC6rITT3o8EGS"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WKnhYIhCC6rITT3o8EGS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-09 at 16:23 +0800, Huang Shijie wrote:
> When we scan several nand chips with nand_scan(), such as
>      .......................
>       nand_scan(*, 2);
>      .......................
>=20
> In nand_scan_ident(), the maxchips will become 2, so the current code
> will select chip 1 to read the device ID. But the chip 0 is still
> selected in this case.
>=20
> To make the logic clear, we'd better de-select the chip when it is not us=
ed.
>=20
> This patch de-select the nand chip if it is not used any more.
>=20
> Signed-off-by: Huang Shijie <b32955@freescale.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-WKnhYIhCC6rITT3o8EGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQqOsKAAoJECmIfjd9wqK097oQAII5hnjUNqQvq+3s9h8d+O6X
SfYuy7hRLLVRaZnkpjmtU+bajA7C8J0lJza/f4oskiBNRMJ6R1fUS7le6se6StZy
EV1QC+ghUbHFQfHySTfkSPydaNHd4gkZUn0EK7ogu/bcR8cRMhB79Cab1iDqp287
8SUutD8dcCudlm6ezPndUpMFSBQEMDdQEqdpah9fR8JhYIdqQiBdrRQfqCVMvMWQ
MwtYx1CnXSpv3CjFR6fkM5q1QezscfsZOyd2a/VlgAqqNP+0yNLv+Ga5bSWsW/Bp
OMyPR8LsmAAQzOM3qz1z+ItDRDkdASF08qiCQaPcI4BoWtadHDMzQl7JOxAKXVsz
85eNTJfnUdLd1qxi8V7AV+MAAGQOjAkFDTqcV2mh/cCglZTKlYDuSkqFl5nM8KEe
SdUN7ZLe83dAGVXPtj74gr41kAJ3bb3+lR0nbDyjC80CvzGGgEeKz483ocNoIiPt
ZptLkt61av2zfMTi9A93RLFsOLyzg1bV6dW8zFnGJnpgNsrxz8I/4EUh21KH1pD2
TZs6YfRt+SUhswfWLYQeq2T0/g8q6WrtDnohyt4ISiZ9ON0P0XQD5t+6wjkJvEZs
UtrDqacmPGJ8DTSlqIuteJdeYURbR0H7kt5Rkj9G2R0Zf2x+1JEYXVLjIeA4EWj5
5Yzv85W+lk2hsshM+zWZ
=UbnZ
-----END PGP SIGNATURE-----

--=-WKnhYIhCC6rITT3o8EGS--

