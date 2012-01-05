Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab2AEVb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:31:56 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:34442 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab2AEVby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:31:54 -0500
Date: Fri, 6 Jan 2012 08:31:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] use generic pci_iomap on all architectures
Message-Id: <20120106083141.9c14a8d2d09539c6a6c0db75@canb.auug.org.au>
In-Reply-To: <20120105145836.GA2751@redhat.com>
References: <20120105145836.GA2751@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_08_31_41_+1100_Q0QqBWaSy8V9O_y/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_08_31_41_+1100_Q0QqBWaSy8V9O_y/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

[I am not *just* picking on you - others do this as well ...]

On Thu, 5 Jan 2012 16:58:36 +0200 "Michael S. Tsirkin" <mst@redhat.com> wro=
te:
>
> Linus, please pull the following changes for 3.3, thanks a lot!
>=20
> These changes have been on linux-next for a while now.
> They touch a lot of arches and have interdependencies, so merging
> separately seems to make sense, I think.
>=20
> The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b26=
10:
>=20
>   Linux 3.2 (2012-01-04 15:55:44 -0800)

So why have you rebased this?  All this stuff in in linux-next based on
v3.2-rc3 since December 5 (and that version will be in linux-next today
as well unless you update your linux-next branch in the next sort while).

Is there something in v3.2 that interacts with this series of patches?
If so, then you had better delay your pull request and do more testing.
If not, then *don't rebase*.

(and if you do rebase, please make sure that what goes into linux-next is
the *same commits* (not just the same patches) as what Linus is merging)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jan_2012_08_31_41_+1100_Q0QqBWaSy8V9O_y/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBha9AAoJEECxmPOUX5FEJaYP/0nf91UzqarGn/yD3ZIS9PcQ
3l+9uCCy+ImaK30wgcZ56FSf8Im70vmUiNw1j9S99ejiyPErFJ335IHHrrZZics3
Pf7+mIz+1N3CRvLYTUEE6h+yu4ctcF3OYAnF8zb+CyRCGiDNfu235xBUCFbQQsID
v+x8BgDbPq9G+H6Xuw7QF9SHhoGguttIcaOLTfn5g0hI1YQaUAcIPGBwLkLAIgWe
NF89Nq9LXSw/rpmrAbu/ZAV7hT4SnuOTsIg5mconBVUzytVR498H2r795Gd73LVf
4BRgz7o3zH6dOBCto1LXTLqNOv2tQ9A3WEBKgQ/UHSS02fh7WCRpYxHxEUZWTV1C
6Gy8fYY3hFxLkZDQnVYq3hSM3QTVCs3soEHQb/a+yzArmP4kuIRQ4xoXZs0zMjd8
dVfzKFb72iWns13cuD5OXT8TUwxqSme15di/6FhXDRhm2OjgY6rPPOHCA1DIXJP3
QwlrLFJLdF9ILDs49b6GGfVM/sNbhUmxkVgNsF1EpD5sLXny/Pf3eQsJIy0/rWIS
H6GB1ngfelLmjuPJcKcuEx8E5BWOmm1PL3sNRrqurDSKxKBQQ83/U6ahFn+lAGVq
qD21i1NkbMRODYintriNPV4Ui+3TzNshcWbPdvZRGM7+vXHIUJcMAIJQkZ7mVrs7
EHf2ba7n0n3sCp0rBnhO
=SbMx
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_08_31_41_+1100_Q0QqBWaSy8V9O_y/--
