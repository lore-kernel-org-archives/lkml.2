Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1JKBMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 21:12:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42933 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1JKBM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 21:12:29 -0400
Date: Mon, 10 Oct 2011 18:12:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linux Input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Input tree moved back to kernel.org
Message-ID: <20111011011224.GA11832@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

All,

I have moved input tree back to its original place on kernel.org:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git

The structure is still the same: 'for-linus' branch for current work and
'next' (same as master) branch for the next merge window. I will try
keeping version on github up to date as well.

Stephen, could you please update linux-next once more?

BTW, does anyone know how one can update project description with
gitolite?

Thanks!

--=20
Dmitry

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOk5f4AAoJEH70+W8r6ZYqCXoQAKRPBh/8gAUL7HEYxiVoCrRN
UsdfEB+tDkTc9BKhUA3ALlUr5K1iQdXPTq/yzhs/47VJGgFQbrpV2gb23o3eLFuD
Z1IzoAOcbHCjWOKiGE3jxiLTjzlj42pix+xi1o26gNP5oFMwUY8TQE3txAZX3puV
oVf2KAhSCgFE+OG1njty9DpPPhDAQlzPCRMpI/9ARxW3NQqt1vVIcQe+p+IDjfQD
fuc86CTDQlFXkeWMNYxRyG01l93py9mRbIw0LStRGS4b9D2mGypA+1dGGuN/Pf9A
3ZY//FonsqfTZeKuKl4diGqWz5njp5s6gsQxb1EChpb5/yEb7hOzt1DDcB5QJ3Nb
TMY0NGSsFcbZ4ZiHoOpAjMIqCrIclVqMrVs9V6x2D5gifTwN8cG1BkLcUDvvpaU5
mdbP6agMM+kLnsvuCkrvtEd+jksYh5wYYFk22TQUdkPPveiJL1pYaver2JVf5mXU
HEgQnuKGZplUjh60CDa/8VUJzMHuw8Kcpe8sh1Sa5ToKQONlvV0xq+Cy+B76XMyp
N1wzxrNT5d0WMQgcVhNSs3EYGLMDJQH44mXz7vYtP1l5c4snW/QbK0XEHEU2mDGt
Xzq6OXGVLKZ6jgUzFs5msLHV+RgfKqEgiKAgEKGLP4qx4K0AWitEyLR9zfMuk91c
Rknd2OpmnhJQHJpk32rv
=4i/y
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
