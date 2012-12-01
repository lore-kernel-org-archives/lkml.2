Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2LAOpX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:45:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62809 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2LAOpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:45:21 -0500
Date: Sat, 1 Dec 2012 15:45:12 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 0/8] Support for Tegra 2D hardware
Message-ID: <20121201144512.GA18209@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:P2MrERZo4juqNH3qwxc8dbHFXPHIMSt1Jw0Rpj2IFQY
 RoUS0OUl2EQ8Qe3kf/ymVQK1rmf1Nh5PBEejbFIRCTAvW/3sxA
 33ZR9L9Or+GXJmNhVmEWnYDU2QcTqQRf+FTSB4PpjLAJyROyhD
 zcJQI3COZWEveY2y+6l4UImUTT/mFVz/DMZIor7sKRQCY8AT0n
 mMvb+AgAJmZ6UZXib0NXj0YmHPE5rezU16EUIrrhbL0KabV9TN
 2ENNSyD9Dx5yBPkEktz8zqvgtShI6BR/zfQtK1FW47In0j+PrK
 bq4exxGUujN8wK75Wr2KVS0Xnw4SGa0JbDyCXK12xj3KldLKg3
 C7ndZaJ9tgvHjrpxzEmKVzVjLAK56lHDH6r96qIJNWlw4IYyMn
 mrVQcKnt2a4mbTbvtEz2c4zHZhGWxqtMNm8nhfjkmsmuPTwBOG
 u+ZrF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 26, 2012 at 03:19:06PM +0200, Terje Bergstrom wrote:
[...]
> The patch set also adds user space API to tegradrm for accessing
> host1d and 2D. We are preparing also patches to libdrm, but they are
> not yet in condition that they could be sent out.

I did some prototyping on how a libdrm API could look like a few weeks
back. I should clean the patches up some and push them to a public
repository or to the mailing lists for review.

There isn't actually much more than a bit of framework along with two
IOCTLs that allow creating and looking up a Tegra-specific GEM. The
related kernel patches aren't available anywhere since I didn't deem
them ready yet. At that time I wasn't even sure if we'd need special
allocations other than what the dumb BO infrastructure provides. They
implement some parts of what you've implemented in this series as well,
with some slight differences.

Currently these still use the CMA-backed GEM objects but it should be
easy to switch to something backed by the host1x infrastructure once
that's in good shape.

While I can't find the quote right now, I seem to remember that you said
at some point that you were planning on adding some 2D acceleration bits
to libdrm. I don't think that's the right place. That code should rather
go into the DDX. libdrm should instead provide a thin layer on top of
the DRM IOCTLs to manage buffers and submit command streams. I hope I
can finish the cleanup of my libdrm patches over the weekend and push
them out so this may become clearer. Maybe I can even get the
corresponding kernel patches pushed out.

Thierry

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuhf4AAoJEN0jrNd/PrOhNEsP+wReouOOeSVAbncR5IK58UUn
Cngi8dGAVr2QMaa5Ouc9ZV2EXFD1sProryvEy23VAPs0Bsrg0DyCMrDAwWpjzFaS
gIExzX9fWHVmLV7Tt4V9z7q5DXaJa9GgpB/K/P5Csm9dfWvIPKzRfuIYu4HDBSYm
kITwPofRL6JYgxhMVNYkRdDXqM+0+kB5xYxXSQ7ebWTpW5E1qWOemw1xYwr1gizb
yzyBh7obsCoqRDMvW82oubLxLmn7HWzowttGscoMB6u0LUGFQKPZP+D78cybSdpJ
6IP9goFqHZ5qZAGcuR7YJephjiI8jV1cbebXUf/iW0iXp5SHj7D1MU5yQBL2ciGp
4J86p6qa2gtWqOcEAuqAY8C7+SzIWH15Ai9YEyvgRBUL4fCexHQVin0qif5Qq+qb
ZVBc/bgdofmXDyYkkaozsl78nfMxnHKW2qsNb+Vs3bKTF42EzSl4qG+DJm3pDoqV
5a7TZbqvZ9Fd4T5PUxFUy6FmLz1AfWoQ7I4xyMBF1Evfm4pX3OhUxMUw10gNS0vE
hA0tnr7a3r7Qq3ceDvOvr+Tz5Rcn1MaLphclmMOk0mtohVhAxCXg2q4b2N0C6bBC
DEqzMWYHRzc1SOSOFQhOn9D8xMpQOp265uBXlaMXBMYZgmIszdJhl5amE3u/lVNw
CReIF73IT9SSfXF18/kT
=FzI8
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
