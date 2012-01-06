Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab2AFVFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:05:08 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:33072 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759162Ab2AFVFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:05:06 -0500
Date: Fri, 6 Jan 2012 13:05:01 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: Increase resource array mask bit size in
 pcim_iomap_regions()
Message-ID: <20120106130501.5922f688@jbarnes-desktop>
In-Reply-To: <1325721002-6094-1-git-send-email-yinghai@kernel.org>
References: <1325721002-6094-1-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1+rr2BI_NoDwLJoDfZ18Jhe"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1+rr2BI_NoDwLJoDfZ18Jhe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  4 Jan 2012 15:50:02 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> DEVICE_COUNT_RESOURCE will be bigger than 16 when SRIOV supported is enab=
led.
>=20
> Let them pass with int just like pci_enable_resources().
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>=20

Applied, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/1+rr2BI_NoDwLJoDfZ18Jhe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPB2H9AAoJEIEoDkX4Qk9hk/4P/jNlsINAJMY7bwDEKLJN8whh
DVTBTJNe+piSpC5yn9dG+mZBtyY9hh/irCqzLp7U5WyjjI4tQnzwxoA7pnsALqed
U5M7BvqZSobHvkIwqObG1fMyDYRJy1ABAe6b6tjV2A4ktt59kqdqtRyvUKszgIw0
iLn+uRODOLkMcG+bC6Fwjm8ILpST5YY+fTVOPDlh57BEXJWpXVgfA4NiEiH60zob
re39Im5YARqM0yqBO842zJzwDpB1NOWpXRyjznsvZhrGZwrrbc/kz6psG88Sma+2
xEabL9nHeinki/BpIF26Lm+IiWwrZ4F+Bk8qdyksNUjC/GI7hRezCkzZfNEthT3J
4/uY0l5cswmbCdqPEnMEkm2xPoWE7CYol4YAWjxomRjY8GM7Qp6mi0nCKBzf7Mmp
6qJeNWgUMwrY63dKhvCLXSNR67GSy3WwPzfCBXJEpAGgAYx0W7CQh8sVdh6iypa4
4Qb3UThEenDOSnVbP/DDA1NSCTkkHRQ6Bw0uFNgUlAHgvVR3MNusAmGKR8gy1YFB
KTeSRj6MH0Fxy2mrW+l3xprc5gHE+2dLuPIWZuLx+qi198E/4UTxaVs35sLPTxyw
CsbBCt78+RAZKnHwAAmrIpEKnqmZIQlSk4G+t2SHoYpDYLzz4Ye5ZUXvhPU+HWny
EIfPZcjkoFijRMNqDUI4
=z9qV
-----END PGP SIGNATURE-----

--Sig_/1+rr2BI_NoDwLJoDfZ18Jhe--
