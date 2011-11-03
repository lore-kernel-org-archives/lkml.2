Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab1KCDWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:22:53 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43734 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab1KCDWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:22:49 -0400
Date: Thu, 3 Nov 2011 14:22:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-Id: <20111103142241.036d664f3bd36936824b241f@canb.auug.org.au>
In-Reply-To: <20111103125325.c1e20275e3a68498465b5ddf@canb.auug.org.au>
References: <20111103125325.c1e20275e3a68498465b5ddf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Nov_2011_14_22_41_+1100_nyi6aIrkz_QWIkiz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Nov_2011_14_22_41_+1100_nyi6aIrkz_QWIkiz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

On Thu, 3 Nov 2011 12:53:25 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the pci-current tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/pci/ats.c:13:26: fatal error: linux/export.h: No such file or dir=
ectory

So this affected the pci tree as well.  So I have used the pci tree from
next-20111102.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Nov_2011_14_22_41_+1100_nyi6aIrkz_QWIkiz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsgkBAAoJEECxmPOUX5FEFUIP/RNSksvsmDzIVds6BXDArcYw
Ol5kbulIUiqWpg4fJ7igGptjc/4XnlBVEZ1V24HfYU8gGAbCUpXxmaiZvnW+g/BM
v9WEEcsXq+YBMguCw4rBs2lSEj6GB5i1Hn6yVB6+EhEV0LtEWaiONqTJFuNJSqec
rcskw0UCWeU7c6nlx/DHc6BwSmOM/3YWupJ15DEwtOphdywnLh4kmvqfjiO6+74D
g9FGQdSQ1Hg52hf8P3IJca+CxBHmKYslHTKpLcJ9WgcmJCiMC9xNTcBJPQIObM5M
AOelKUirjeLemEnuhay5bRBE4AAtfGZqK+5ia6ezvtWVl0Lz68TEJ+IhdTvnJVyo
8QdFPfUWUKG1PsNpcruzGvO4oDBzeMkpa9qtnDwTd+KQFbeSYCz7ZL9Qfzsdtd/n
p1mXw4YQVZF00Dde6E334cKElWzZiujpYYBNBf2jFiH/3EsRGWKzdYebmAfpGoMN
5khaofoDY35/TSEn/wFJxnsZ58c6Sv85+mEDVtK99e24KHMScq0IfkibQnz0OFAI
3vi07LKOblI/nB2GfzQWwo27D5MUgSW0XOTUOMcY2gzIViakB/MOaV1SQbxNOxTY
7Oi7DSbmdviPi/kC2EWdoxcX2bMBmoNB5Zt3gLzwAY/EYYg5BCFmvohWwrAFndCf
sKV2QZYibV/YEFu/heXf
=Bu9E
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Nov_2011_14_22_41_+1100_nyi6aIrkz_QWIkiz--
