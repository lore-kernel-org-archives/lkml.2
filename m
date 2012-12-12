Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2LLXrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:47:49 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53619 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2LLXrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:47:48 -0500
Date: Thu, 13 Dec 2012 10:47:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/5] [GIT PULL] ktest: fixes and updated for new boot
 loaders
Message-Id: <20121213104736.bd2094f856d459edae2d9529@canb.auug.org.au>
In-Reply-To: <20121212221437.245229327@goodmis.org>
References: <20121212221437.245229327@goodmis.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Dec_2012_10_47_36_+1100_DeB3n6frIrpqhHEj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Dec_2012_10_47_36_+1100_DeB3n6frIrpqhHEj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Wed, 12 Dec 2012 17:14:37 -0500 Steven Rostedt <rostedt@goodmis.org> wro=
te:
>
> Please pull the latest ktest-v3.8 tree, which can be found at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
> ktest-v3.8
>=20
> Head SHA1: a7c85ac16cf29aa0fec5fef2fe26bb09a9e3ee19
>=20
>=20
> Steven Rostedt (5):
>       ktest: Add support for grub2
>       ktest: Sync before reboot
>       ktest: Add native support for syslinux boot loader
>       ktest: Fix breakage from change of oldnoconfig to olddefconfig
>       ktest: Test if target machine is up before install

Just a bit disappointed that none of this made ever it into your for-next
branch (and hence linux-next) ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Dec_2012_10_47_36_+1100_DeB3n6frIrpqhHEj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQyReYAAoJEECxmPOUX5FEYNMP/R82iSNxXWYTj0jbcF0xaaFa
CYghyTHZraIDDqifsgTW3XTw0Doi3SQfuIv/pdxRpPUbs+v3TFhVtZmH5TKMHXVP
XfUX1varIqxi11BTiH1uZ07Fq95aNoBK6eAdZwvW03L3U0cCKF+r0wIHzy9deHpd
JLbhlFnq/50P4zFWJbGkStADZL+hu70OoW7XrHZJEnMSmogWlKc8mpv/mVfKb7Zn
G8NluDz6FGqYpvqWH8ccklnzgplJI8wGLDKQJK5lzY9+yVtaQOihBGL1VoozF0R0
k8G3ttPonDKB4YV4DZJAEzKqCjO0pjqUZy8To+2oNGH1WqV6yFZf/pMwMBW8VDsz
F8qBH1iH2if439/+lbF1dNNL6wsW6VjZB3IIo+p2Zpbx4NzjDzeYQVOJs+1/DSAI
jsADjmVSJ/tlC2WX7cgaD72f1ewxTa/hTssZ2MkQDPDXdtMZ5FE5bwdZgKiQ46f2
Pb3Yypd6ig8I3ojce7fqHL3sSPO1WpUGkAh+cHc1SKegj4CzRTZViIWavPeSmDer
GzFL4ZKFjMAMMzDPRK8opmmwxZARHFPNRe6xN6oS70d49r7ezp1Gu0220XFckQOs
tOX4GnKy7AQYCi15btmG2eKeBNDjvno7tnIiafPuH1+8hp8ew49d/NX3SaQWXGnV
u5ZddbosYSBwaglKC7kC
=D+Ix
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Dec_2012_10_47_36_+1100_DeB3n6frIrpqhHEj--
