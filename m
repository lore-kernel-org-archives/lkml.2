Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1IOAJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 20:09:46 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:51055 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1IOAJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 20:09:43 -0400
Date: Thu, 15 Sep 2011 10:09:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Temporary ext4 tree location
Message-Id: <20110915100931.ebba20dcbe93d41c6115ecc7@canb.auug.org.au>
In-Reply-To: <20110914154910.GC3429@dhcp-172-31-195-159.cam.corp.google.com>
References: <20110914154910.GC3429@dhcp-172-31-195-159.cam.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Sep_2011_10_09_31_+1000_AJ65v1XXDlHgpJxa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Sep_2011_10_09_31_+1000_AJ65v1XXDlHgpJxa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

On Wed, 14 Sep 2011 11:49:10 -0400 Ted Ts'o <tytso@mit.edu> wrote:
>
> -----BEGIN PGP SIGNED MESSAGE-----

[ Good plan, but I havne't got a trust path to your key :-( cc'd to lkml
just so that the real Ted may see it and scream if necessary :-) ]

> The temporary ext4 tree (for linux-next purposes) is at:
>=20
>         git://github.com/tytso/ext4.git	dev
>=20
> I've previously sent changes to Linus using this git tree at github.

OK, I will switch to this tree from today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Sep_2011_10_09_31_+1000_AJ65v1XXDlHgpJxa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcUI7AAoJEDMEi1NhKgbs+0oH/0CjlgT5XVhd49fNcCuDOJ+S
oiYdboQwjX7FiZqxFEOy6CEpkQN2AAh8DxKngnCFCufonU00Trye8k+4282YwLfC
i2jTAVFEhcxUcQPUSqJjTZg/gt9P3RNUXeqZ60hKGdFCzhNxQtVXcvw0VOcWw9hU
X6AQ9IjS6oI7bwAMOCHYzK+6Z2I2qM+63QJmcqAN8DLq3sDIuQZ2ESI9IYguBCmi
SkgYz8UZOTgNltGoIf5EAAhaXXTH/dTJj4GGiEHxd9nC5dP2UM/bNoDiuln3BjyK
1FxOLDPgbB05Rvjz679QX/K3Q8ZGuuz6RYiC3Dgz+rqKyRPjI/WGFtnreL2TZjI=
=RuRg
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Sep_2011_10_09_31_+1000_AJ65v1XXDlHgpJxa--
