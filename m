Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2LMKjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 05:39:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36984 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab2LMKjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 05:39:31 -0500
Date: Thu, 13 Dec 2012 21:39:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: reminder 2
Message-Id: <20121213213922.b4474411b2370bb8432cf9eb@canb.auug.org.au>
In-Reply-To: <s5hobhyqoem.wl%tiwai@suse.de>
References: <20121213153237.403367211eb1a82e2cdaabb2@canb.auug.org.au>
	<s5hobhyqoem.wl%tiwai@suse.de>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Dec_2012_21_39_22_+1100_.hEoO_vt4ao+IDI8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Dec_2012_21_39_22_+1100_.hEoO_vt4ao+IDI8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

On Thu, 13 Dec 2012 10:42:09 +0100 Takashi Iwai <tiwai@suse.de> wrote:
>
> At Thu, 13 Dec 2012 15:32:37 +1100,
> Stephen Rothwell wrote:
> >=20
> > If you have a tree that is included in linux-next, please clean it up
> > after it has been merged into your upstream (i.e. Linus' tree in most
> > cases).
>=20
> What does "clean up" mean in this context exactly?

Well, if the tree you had in linux-next is pulled directly into Linus'
tree, then you have nothing to do (except maybe a fast forward back merge
of Linus' tree past the point your tree was merged).

If your tree in linux-next is a merge of other branches that are merged
into Linus' tree separately, then after they are all merged upstream, you
should reset your tree to somewhere in Linus' tree.

If you rebased your tree before sending it to Linus (which you should not
do, of course), and don't update what is in linux-next to match (which
you should also not do :-)), then you should scold your self (:-)) and
reset your tree to be somewhere in Linus' tree.

The intent is to give you somewhere nice and clean to start collecting
your next set of commits for the next release (or bug fixes etc) and to
minimise the conflicts with what is left in linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Dec_2012_21_39_22_+1100_.hEoO_vt4ao+IDI8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQybBaAAoJEECxmPOUX5FE6K4P/0Ozu98WvONUCJAtDk4k9rMB
LnrEqd5DXQzSck/hXRD5tFxIsdBw4hNCs310dOSrDXVdc/NXHMJiuQu6AlPK4I3s
+uCLmhxtPZUm+xCUHRFYI8KbLtZyPuskPnmN97ua42QuACjg2IX+3mJfxoh5RutL
EeAks4HojIhbp2+b9b/5uqly0rjA3Vtwqo5vVvWNiG+Tbwmx1L56KdPXabwzhr+6
Z6CUUYoJWenPYREmqJfmL7wDA+GM7putLKrNRl93U/WA3gv4Ur2Rsbj57P3vvozt
fY9cjsRMaZXHC0N8vQ2Ecwn9tqjYGHODUxk69NetLSShYG51+c5QdclMiCcFuFIX
ruYiquWMWRUhq8HE378hFbHK1S2wWjilLF101sRR8rETRrMHuZew51tDsJjpuY7u
+Hgg1RXN0prvcaIxSrA7GnCVpOqMpiUSmntw+xh2Oc1nRYLyLVyLxJhSb+WlwniG
s1Rhl1p6Jkp4Tpf2/R0JmOil5OcO0VIHOAB5li2xwIZf+Q3EvOcdKBqP3PY1am/K
hCR5lREhQEg0y93HMEkzU5nqZIHDbW5GtsF68fD5pzievhXYAYO7YlDpjXdAMi6i
bOOk6Sf2NzeXPmcfmUV5A7pGLm0hAdtkGpc3qGkJPVoa8NfYye6w8nh+bHqSzRBa
pMw++/Gm/9mUVG1+dTOx
=/Fky
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Dec_2012_21_39_22_+1100_.hEoO_vt4ao+IDI8--
